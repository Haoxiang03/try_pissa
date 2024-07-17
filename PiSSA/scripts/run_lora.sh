BASE_MODEL=/hpc_stor03/sjtu_home/haoxiang.jiang/PiSSA/llama3-8b
OUTPUT_PATH=/hpc_stor03/sjtu_home/haoxiang.jiang/PiSSA/outputs/lora
DATA_PATH=/hpc_stor03/sjtu_home/haoxiang.jiang/PiSSA/mathqa

# batch size = per_device_train_batch_size * gradient_accumulation_steps * num_gpus = 128
deepspeed --master_port=54633 --include=localhost:0,1,2,3,4,5,6,7 /hpc_stor03/sjtu_home/haoxiang.jiang/PiSSA/pissa.py \
    --deepspeed /hpc_stor03/sjtu_home/haoxiang.jiang/PiSSA/configs/ds_config_zero2_no_offload.json \
    --model_name_or_path $BASE_MODEL \
    --use_lora True \
    --init_lora_weights True \
    --target_modules "q_proj,v_proj,k_proj,o_proj,gate_proj,down_proj,up_proj" \
    --lora_rank 128 \
    --lora_alpha 128 \
    --lora_dropout 0 \
    --data_path $DATA_PATH \
    --dataset_field query response \
    --dataset_split "train[:100000]"\
    --output_dir $OUTPUT_PATH \
    --num_train_epochs 1 \
    --model_max_length 512 \
    --per_device_train_batch_size 4 \
    --gradient_accumulation_steps 4 \
    --save_strategy "steps" \
    --save_steps 100 \
    --save_total_limit 100 \
    --learning_rate 2e-5 \
    --weight_decay 0. \
    --warmup_ratio 0.03 \
    --logging_steps 1 \
    --lr_scheduler_type "cosine" \
    --report_to "tensorboard" \
    --merge True \
