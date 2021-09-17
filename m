From: brookxu <brookxu.cn@gmail.com>
Subject: Re: [PATCH v3 2/3] misc_cgroup: remove error log to avoid log flood
Date: Fri, 17 Sep 2021 09:56:26 +0800
Message-ID: <eece1309-4c1e-909a-22ea-3db31ad7a1da@gmail.com>
References: <3834f917d50a6f19402e179e917ef6a9dde5f64a.1631671936.git.brookxu@tencent.com>
 <a960cd793f649bd944127fe5e5e3f4d8bb9040a4.1631671936.git.brookxu@tencent.com>
 <20210916175711.GA12643@blackbody.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=zdlBFrQubRXdUqdsVIqT/f0kDrO2skTyaf0KO7tBrEA=;
        b=Mm2mXvEmWnkptp65WTD/gcjpkxrVxksIJDvdZDvgHI6cEi5LGPVpNOLCxvzKWLk4NN
         mnF+nfWG/Xv/QVKeWwa7t1wa5NNH8xeUCdyTmKUrSooxGFE8oz89B+Q0BX8lONlE9LeW
         0sI9um0vnWjkWx7NfuRjc9xI3nBce0M16bpA7u1uI7ZQeiw229KqTvZKZcwFyLrLVW5I
         XlwYYmYV9Tkk5jBUlLrGTDbmGX5oseINzQ7WnQHiQl7RfIeyExo08fir0L66wd6uMOl3
         MVkmq+c5fY75mYTjwFd46+jTsA9ZqLp/W+vw959b4hSftgcER7wWk03a5gvMTgfVUUFJ
         kNLA==
In-Reply-To: <20210916175711.GA12643@blackbody.suse.cz>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny@suse.com>
Cc: tj@kernel.org, lizefan.x@bytedance.com, hannes@cmpxchg.org, vipinsh@google.com, corbet@lwn.net, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org

Thanks for your time.

Michal Koutný wrote on 2021/9/17 1:57 上午:
> On Wed, Sep 15, 2021 at 10:18:50AM +0800, brookxu <brookxu.cn@gmail.com> wrote:
>> In scenarios where containers are frequently created and deleted,
>> a large number of error logs maybe generated. This log provides
>> less information, we can get more detailed info from misc.events.
> 
> IIUC, the log provides equal information (with persistence), no?
> 
>> diff --git a/kernel/cgroup/misc.c b/kernel/cgroup/misc.c
>> index 4b2b492..fe3e8a0 100644
>> --- a/kernel/cgroup/misc.c
>> +++ b/kernel/cgroup/misc.c
>> @@ -157,13 +157,6 @@ int misc_cg_try_charge(enum misc_res_type type, struct misc_cg *cg,
>>  		new_usage = atomic_long_add_return(amount, &res->usage);
>>  		if (new_usage > READ_ONCE(res->max) ||
>>  		    new_usage > READ_ONCE(misc_res_capacity[type])) {
>> -			if (!res->failed) {
>> -				pr_info("cgroup: charge rejected by the misc controller for %s resource in ",
>> -					misc_res_name[type]);
>> -				pr_cont_cgroup_path(i->css.cgroup);
>> -				pr_cont("\n");
>> -				res->failed = true;
>> -			}
> 
> As I argued previously, reporting this as "in" `i` cgroup instead
> of `cg` is not that useful and equivalent to the misc.events:*.max now,
> so the drop is appropriate.
> 
> The change/patch is OK,
> Reviewed-by: Michal Koutný <mkoutny@suse.com>
> 
> The commit message might be fixed (if you agree with remark).

Yeah, maybe we should make it more clearly, What do you think of
the commit below:

In scenarios where containers are frequently created and deleted,
a large number of error logs maybe generated. The logs only show
which node is about to go over the max limit, not the node which
resource request failed. As misc.event has provided relevant
information, maybe we can remove this log.


> 
