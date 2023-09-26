From: "Haitao Huang" <haitao.huang@linux.intel.com>
Subject: Re: [PATCH v5 01/18] cgroup/misc: Add per resource callbacks for CSS
 events
Date: Mon, 25 Sep 2023 22:04:17 -0500
Message-ID: <op.2buytfetwjvjmi@hhuan26-mobl.amr.corp.intel.com>
References: <20230923030657.16148-1-haitao.huang@linux.intel.com>
 <20230923030657.16148-2-haitao.huang@linux.intel.com>
 <CVS5XFKKTTUZ.XRMYK1ADHSPG@suppilovahvero>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1695697462; x=1727233462;
  h=to:cc:subject:references:date:mime-version:
   content-transfer-encoding:from:message-id:in-reply-to;
  bh=2bxMWcQV7aRui1UuOAzcGKmeuETYed3NCdfqWTKxnPg=;
  b=JPLuIhdHmuourxB5ObKfx0tP7nrIY/angXy3i0My69HXDH6ZwGLyEXie
   E9j6gR6TAPHmTG1WI9aEpPPLcfcqd+RppM+XAJRakBxIsaSLthBHOkmQ0
   QNNEvrYyjzjmHIEEWtrX/wVv8I5GwdpQ8IzbbbX3qTjChjD5e/yHxT6f6
   tJqSkH3uqyUdaW6VNhaOCaA5Pgi7suX7Fs99kLXeT/dGV/dAi1oXa6+bk
   lD+S/QYJou7pUsXg6uvdF2aPt/jBbOogart+NXz3/yjSBAttGkxhK3gDh
   YcFEDf3Z8ZRqNCdk0kZlErMKm8vyjrMppZiNzN4/GCP4dL21orLUaXfgt
   Q==;
In-Reply-To: <CVS5XFKKTTUZ.XRMYK1ADHSPG@suppilovahvero>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"; delsp="yes"
To: dave.hansen@linux.intel.com, tj@kernel.org, linux-kernel@vger.kernel.org, linux-sgx@vger.kernel.org, x86@kernel.org, cgroups@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com, sohil.mehta@intel.com, Jarkko Sakkinen <jarkko@kernel.org>
Cc: zhiquan1.li@intel.com, kristen@linux.intel.com, seanjc@google.com, zhanb@microsoft.com, anakrish@microsoft.com, mikko.ylinen@linux.intel.com, yangjie@microsoft.com

Hi Jarkko

On Mon, 25 Sep 2023 12:09:21 -0500, Jarkko Sakkinen <jarkko@kernel.org>  
wrote:

> On Sat Sep 23, 2023 at 6:06 AM EEST, Haitao Huang wrote:
>> From: Kristen Carlson Accardi <kristen@linux.intel.com>
>>
>> The misc cgroup controller (subsystem) currently does not perform
>> resource type specific action for Cgroups Subsystem State (CSS) events:
>> the 'css_alloc' event when a cgroup is created and the 'css_free' event
>> when a cgroup is destroyed, or in event of user writing the max value to
>> the misc.max file to set the usage limit of a specific resource
>> [admin-guide/cgroup-v2.rst, 5-9. Misc].
>>
>> Define callbacks for those events and allow resource providers to
>> register the callbacks per resource type as needed. This will be
>> utilized later by the EPC misc cgroup support implemented in the SGX
>> driver:
>> - On css_alloc, allocate and initialize necessary structures for EPC
>> reclaiming, e.g., LRU list, work queue, etc.
>> - On css_free, cleanup and free those structures created in alloc.
>> - On max_write, trigger EPC reclaiming if the new limit is at or below
>> current usage.
>>
>> Signed-off-by: Kristen Carlson Accardi <kristen@linux.intel.com>
>> Signed-off-by: Haitao Huang <haitao.huang@linux.intel.com>
>> ---
>> V5:
>> - Remove prefixes from the callback names (tj)
>> - Update commit message (Jarkko)
>>
>> V4:
>> - Moved this to the front of the series.
>> - Applies on cgroup/for-6.6 with the overflow fix for misc.
>>
>> V3:
>> - Removed the released() callback
>> ---
>>  include/linux/misc_cgroup.h |  5 +++++
>>  kernel/cgroup/misc.c        | 32 +++++++++++++++++++++++++++++---
>>  2 files changed, 34 insertions(+), 3 deletions(-)
>>
>> diff --git a/include/linux/misc_cgroup.h b/include/linux/misc_cgroup.h
>> index e799b1f8d05b..96a88822815a 100644
>> --- a/include/linux/misc_cgroup.h
>> +++ b/include/linux/misc_cgroup.h
>> @@ -37,6 +37,11 @@ struct misc_res {
>>  	u64 max;
>>  	atomic64_t usage;
>>  	atomic64_t events;
>> +
>> +	/* per resource callback ops */
>> +	int (*alloc)(struct misc_cg *cg);
>> +	void (*free)(struct misc_cg *cg);
>> +	void (*max_write)(struct misc_cg *cg);
>>  };
>>
>>  /**
>> diff --git a/kernel/cgroup/misc.c b/kernel/cgroup/misc.c
>> index 79a3717a5803..62c9198dee21 100644
>> --- a/kernel/cgroup/misc.c
>> +++ b/kernel/cgroup/misc.c
>> @@ -276,10 +276,13 @@ static ssize_t misc_cg_max_write(struct  
>> kernfs_open_file *of, char *buf,
>>
>>  	cg = css_misc(of_css(of));
>>
>> -	if (READ_ONCE(misc_res_capacity[type]))
>> +	if (READ_ONCE(misc_res_capacity[type])) {
>>  		WRITE_ONCE(cg->res[type].max, max);
>> -	else
>> +		if (cg->res[type].max_write)
>> +			cg->res[type].max_write(cg);
>> +	} else {
>>  		ret = -EINVAL;
>> +	}
>>
>>  	return ret ? ret : nbytes;
>>  }
>> @@ -383,23 +386,39 @@ static struct cftype misc_cg_files[] = {
>>  static struct cgroup_subsys_state *
>>  misc_cg_alloc(struct cgroup_subsys_state *parent_css)
>>  {
>> +	struct misc_cg *parent_cg;
>>  	enum misc_res_type i;
>>  	struct misc_cg *cg;
>> +	int ret;
>>
>>  	if (!parent_css) {
>>  		cg = &root_cg;
>> +		parent_cg = &root_cg;
>>  	} else {
>>  		cg = kzalloc(sizeof(*cg), GFP_KERNEL);
>>  		if (!cg)
>>  			return ERR_PTR(-ENOMEM);
>> +		parent_cg = css_misc(parent_css);
>>  	}
>>
>>  	for (i = 0; i < MISC_CG_RES_TYPES; i++) {
>>  		WRITE_ONCE(cg->res[i].max, MAX_NUM);
>>  		atomic64_set(&cg->res[i].usage, 0);
>> +		if (parent_cg->res[i].alloc) {
>> +			ret = parent_cg->res[i].alloc(cg);
>> +			if (ret)
>> +				goto alloc_err;
>> +		}
>>  	}
>>
>>  	return &cg->css;
>> +
>> +alloc_err:
>> +	for (i = 0; i < MISC_CG_RES_TYPES; i++)
>> +		if (parent_cg->res[i].free)
>> +			cg->res[i].free(cg);
>> +	kfree(cg);
>> +	return ERR_PTR(ret);
>>  }
>>
>>  /**
>> @@ -410,7 +429,14 @@ misc_cg_alloc(struct cgroup_subsys_state  
>> *parent_css)
>>   */
>>  static void misc_cg_free(struct cgroup_subsys_state *css)
>>  {
>> -	kfree(css_misc(css));
>> +	struct misc_cg *cg = css_misc(css);
>> +	enum misc_res_type i;
>> +
>> +	for (i = 0; i < MISC_CG_RES_TYPES; i++)
>> +		if (cg->res[i].free)
>> +			cg->res[i].free(cg);
>> +
>> +	kfree(cg);
>>  }
>>
>>  /* Cgroup controller callbacks */
>> --
>> 2.25.1
>
> Since the only existing client feature requires all callbacks, should
> this not have that as an invariant?
>
> I.e. it might be better to fail unless *all* ops are non-nil (e.g. to
> catch issues in the kernel code).
>

These callbacks are chained from cgroup_subsys, and they are defined  
separately so it'd be better follow the same pattern.  Or change together  
with cgroup_subsys if we want to do that. Reasonable?

Thanks
Haitao
