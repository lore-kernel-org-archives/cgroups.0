From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCHSET v2 block/for-5.8] iocost: improve use_delay and latency
 target handling
Date: Thu, 30 Apr 2020 15:55:30 -0600
Message-ID: <6ee6360e-1a35-874c-2263-6fb21da66591@kernel.dk>
References: <20200413162758.97252-1-tj@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=rYEprxh5hRkyIRk0SZJ1yYwJF2zaPFW1K1pdxuC7Zuc=;
        b=0YJweBxdqRGXk8CKADPYZT2TDMDjlejyhecZFIP6Pdqu2Rol0vua+RkjawOc6lW+4C
         uye8FqmbkqGQFahJuYyZ/sVkYDn8YKcognO7HZN5LGsmML6yIXlmeCxIkANnyZNQ1gTG
         /9xSR/dOm1broZSmXWyPapxeqpe3M9DwJQedEjQkHUFGZC4OxPB9a94qfaCo8FkfLTG2
         z4UdgSMg6xqZqbdaMkkKFbSj8MCsvkht1TJbHhLVLcwEjDr92euBMUJXifl8yCQybF3i
         0VWB+PK6QrXPrkeZTzbIW4Ds0P1gdgZDHzx3P27ENgTnRXQIqNtK/jjJtTG7opYmGATG
         kgeg==
In-Reply-To: <20200413162758.97252-1-tj@kernel.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, cgroups@vger.kernel.org, newella@fb.com, josef@toxicpanda.com, asml.silence@gmail.com, ming.lei@redhat.com, bvanassche@acm.org

On 4/13/20 10:27 AM, Tejun Heo wrote:
> Changes from v1[1]
> 
> * Dropped 0002-block-add-request-io_data_len.patch and updated to use
>   rq->stats_sectors instead as suggested by Pavel Begunkov.
> 
> This patchset improves the following two iocost control behaviors.
> 
> * iocost was failing to punish heavy shared IO generators (file metadata, memory
>   reclaim) through use_delay mechanism - use_delay automatically decays which
>   works well for iolatency but doesn't match how iocost behaves. This led to
>   e.g. memory bombs which generate a lot of swap IOs to use over their allotted
>   amount. This is fixed by adding non-decaying use_delay mechanism.
> 
> * The same latency targets were being applied regardless of the IO sizes. While
>   this works fine for loose targets, it gets in the way when trying to tigthen
>   them - a latency target adequate for a 4k IO is too short for a 1 meg IO.
>   iocost now discounts the size portion of cost when testing whether a given IO
>   met or missed its latency target.
> 
> While at it, it also makes minor changse to iocost_monitor.py.
> 
> This patchset contains the following five patches.
> 
>  0001-blk-iocost-switch-to-fixed-non-auto-decaying-use_del.patch
>  0002-blk-iocost-account-for-IO-size-when-testing-latencie.patch
>  0003-iocost_monitor-exit-successfully-if-interval-is-zero.patch
>  0004-iocost_monitor-drop-string-wrap-around-numbers-when-.patch
> 
> and is also available in the following git branch.
> 
>  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git iocost-delay-latency-v2
> 
> diffstat follows. Thanks.
> 
>  block/Kconfig                  |    1 
>  block/blk-cgroup.c             |    6 ++++
>  block/blk-iocost.c             |   56 +++++++++++++++++++++++++++++------------
>  include/linux/blk-cgroup.h     |   43 ++++++++++++++++++++++++-------
>  tools/cgroup/iocost_monitor.py |   48 +++++++++++++++++++----------------
>  5 files changed, 106 insertions(+), 48 deletions(-)

Applied, thanks Tejun.

-- 
Jens Axboe

