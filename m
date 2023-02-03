From: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Subject: Re: switch blk-cgroup to work on gendisk v4
Date: Fri, 03 Feb 2023 10:18:08 -0700
Message-ID: <167544468813.66559.10558458278064918482.b4-ty@kernel.dk>
References: <20230203150400.3199230-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=i/gOe5c4d8g4HlmwXcDcqeT+1g0VQI8Av9sZXDtgtRk=;
        b=wVGuDktsLDUFo44IpWODMNa/V8eF+q+w1L52f/+4zRlfsZAuFkNhv4yLmxi4maRo1n
         1tOFM2J+e2CKebBqs6wVbOt3NisbDGPQu+jkrFm3oI0eZa1GTCzsvx9mw1AKj4et8HPz
         JBMjU/CkPQBFSlQfu0kiwJdOfB1WMLrhO9Qfg0yWCh/FUuNtLiwBIEdypM6+sP37X1cA
         wi/wQS1P+txRXfrn5WWYPcwmzqY8mzCBQaiy02DT8U59sI84cGD44nRntk72w84X8lpI
         nSARdEYOnSAhWtRSVas+02Tl0WztFcWo1mYf8ANNGfhm2KOcg+cejCtuwEjDD/6pVLGc
         3+GA==
In-Reply-To: <20230203150400.3199230-1-hch-jcswGhMUV9g@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Josef Bacik <josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


On Fri, 03 Feb 2023 16:03:41 +0100, Christoph Hellwig wrote:
> blk-cgroup works on only on live disks and "file system" I/O from bios.
> This all the information should be in the gendisk, and not the
> request_queue that also exists for pure passthrough request based
> devices.
> 
> Changes since v3:
>  - improve a commit log
>  - drop a change to not acquire a pointless disk reference
> 
> [...]

Applied, thanks!

[01/19] block: don't call blk_throtl_stat_add for non-READ/WRITE commands
        commit: a886001c2da8dd02357d0d336ddb021903347f89
[02/19] blk-cgroup: delay blk-cgroup initialization until add_disk
        commit: 178fa7d49815ea8001f43ade37a22072829fd8ab
[03/19] blk-cgroup: improve error unwinding in blkg_alloc
        commit: 0b6f93bdf07e52620f725f721e547408e0d04c9d
[04/19] blk-cgroup: simplify blkg freeing from initialization failure paths
        commit: 27b642b07a4a5eb44dffa94a5171ce468bdc46f9
[05/19] blk-cgroup: remove the !bdi->dev check in blkg_dev_name
        commit: 180b04d450a7137270c12dbb6bebf1d5e6c0a6f2
[06/19] blk-cgroup: pin the gendisk in struct blkcg_gq
        commit: 84d7d462b16dd5f0bf7c7ca9254bf81db2c952a2
[07/19] blk-cgroup: store a gendisk to throttle in struct task_struct
        commit: f05837ed73d0c73e950b2d9f2612febb0d3d451e
[08/19] blk-wbt: pass a gendisk to wbt_{enable,disable}_default
        commit: 04aad37be1a88de6a1919996a615437ac74de479
[09/19] blk-wbt: pass a gendisk to wbt_init
        commit: 958f29654747a54f2272eb478e493eb97f492e06
[10/19] blk-wbt: move private information from blk-wbt.h to blk-wbt.c
        commit: 0bc65bd41dfd2f75b9f38812326d767db5cd0663
[11/19] blk-wbt: open code wbt_queue_depth_changed in wbt_init
        commit: 4e1d91ae876bd12f327340f11a16a1278985e7e1
[12/19] blk-rq-qos: move rq_qos_add and rq_qos_del out of line
        commit: b494f9c566ba5fe2cc8abe67fdeb0332c6b48d4b
[13/19] blk-rq-qos: make rq_qos_add and rq_qos_del more useful
        commit: ce57b558604e68277d31ca5ce49ec4579a8618c5
[14/19] blk-rq-qos: constify rq_qos_ops
        commit: 3963d84df7974b6687cb34bce3b9e0b2686f839c
[15/19] blk-rq-qos: store a gendisk instead of request_queue in struct rq_qos
        commit: ba91c849fa50dbc6519cf7808177b3a9b7f6bc97
[16/19] blk-cgroup: pass a gendisk to blkcg_{de,}activate_policy
        commit: 40e4996ec099a301083eb7e29095ebdfc31443da
[17/19] blk-cgroup: pass a gendisk to pd_alloc_fn
        commit: 0a0b4f79db2e6e745672aa3852cf5fdf7af14a0f
[18/19] blk-cgroup: pass a gendisk to blkg_lookup
        commit: 479664cee14d8452d3d76f8d0b7fccd0cbe4ed49
[19/19] blk-cgroup: move the cgroup information to struct gendisk
        commit: 3f13ab7c80fdb0ada86a8e3e818960bc1ccbaa59

Best regards,
-- 
Jens Axboe



