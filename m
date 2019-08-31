From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCHSET block/for-next] IO cost model based work-conserving
 porportional controller
Date: Sat, 31 Aug 2019 04:20:10 -0700
Message-ID: <20190831112010.GG2263813@devbig004.ftw2.facebook.com>
References: <20190614015620.1587672-1-tj@kernel.org>
 <20190614175642.GA657710@devbig004.ftw2.facebook.com>
 <5A63F937-F7B5-4D09-9DB4-C73D6F571D50@linaro.org>
 <B5E431F7-549D-4FC4-A098-D074DF9586A1@linaro.org>
 <20190820151903.GH2263813@devbig004.ftw2.facebook.com>
 <9EB760CE-0028-4766-AE9D-6E90028D8579@linaro.org>
 <20190831065358.GF2263813@devbig004.ftw2.facebook.com>
 <73CA9E04-DD93-47E4-B0FE-0A12EC991DEF@linaro.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=LvmGRX4LOdsdUyhqS2DocPUCGusSGnHnPDwLS+tUYBw=;
        b=PK/UUpMIz6vGKESR/qWrB73mE5YrMA3srDYvsuYkZrvinUDXGVxGQ5MG3gdvcVS07j
         ZfANEcE/6el1beaQ4LSh3G1MTb05PufyP/OU6Q0VQOb2cDAcrIxDzvSZv+FYVzrntCvQ
         tTWEaEuJyTtf8N2g7gXdNHT7+q8SLvbxI/heNodCYdg+heOHOoAdjPP4Vsu3obkzZWSe
         H5W7JInfDelMo6SSnpOS6d0F9x0aIdjeq9YYKXaxhbj3w9W8nmYuGb4t7T/SW7pQKzB/
         097wawu8tSWVKZF9uRH0rbsWAQ5AUeikdovBIDTVghW4ccY/51t6WwfqP70a9c4bACZh
         jL9Q==
Content-Disposition: inline
In-Reply-To: <73CA9E04-DD93-47E4-B0FE-0A12EC991DEF@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Paolo Valente <paolo.valente@linaro.org>
Cc: Jens Axboe <axboe@kernel.dk>, newella@fb.com, clm@fb.com, Josef Bacik <josef@toxicpanda.com>, dennisz@fb.com, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-block <linux-block@vger.kernel.org>, kernel-team@fb.com, cgroups@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net, kafai@fb.com, songliubraving@fb.com, yhs@fb.com, bpf@vger.kernel.org

Hello,

On Sat, Aug 31, 2019 at 09:10:26AM +0200, Paolo Valente wrote:
> Hi Tejun,
> thank you very much for this extra information, I'll try the
> configuration you suggest.  In this respect, is this still the branch
> to use
> 
> https://kernel.googlesource.com/pub/scm/linux/kernel/git/tj/cgroup/+/refs/heads/review-iocost-v2
> 
> also after the issue spotted two days ago [1]?

block/for-next is the branch which has all the updates.

  git://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-block.git for-next

Thanks.

-- 
tejun
