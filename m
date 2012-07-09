From: Sha Zhengju <handai.szj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 6/7] memcg: add per cgroup writeback pages accounting
Date: Mon, 09 Jul 2012 11:36:11 +0800
Message-ID: <4FFA51AB.30203@gmail.com>
References: <1340880885-5427-1-git-send-email-handai.szj@taobao.com> <1340881562-5900-1-git-send-email-handai.szj@taobao.com> <20120708145309.GC18272@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        bh=cmxcr1/XQrsiCqAPl0NZWugosJv17JlUoSYdMM4mdlg=;
        b=Z9z4XQOUbE/33B/lLsKilcyjXIs6zDBuWr52bjs0BqLLHJwoDkKW7zEEmPq5NEtZPg
         CWjJudl3zyFc01wttxOZfAScyZqKYUKPwY4+fSF9Nh+NiA9YRMhhuepMlwq1M/s2SwTh
         kCPRiYm9D++BBFAHRsYnJFRwW6C5Tbw+CP7g1kf2ZNtd0mz1ddmTNmrfzhz8smIPReMr
         WcHo9NMTg2YdtytvSwzh5KSEGmTOR8FrgYse7E7YSpCewML/nEvwA1rk5s4xlZXkp8VL
         VGLffRe6saz4MPXX7wzh0maUP3Eg09JOiHp/ALiGOoFwCHBIgJvQg2abNdwmBcuJENyn
         opsg==
In-Reply-To: <20120708145309.GC18272@localhost>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Fengguang Wu <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>

On 07/08/2012 10:53 PM, Fengguang Wu wrote:
>> @@ -2245,7 +2252,10 @@ int test_set_page_writeback(struct page *page)
>>   {
>>   	struct address_space *mapping = page_mapping(page);
>>   	int ret;
>> +	bool locked;
>> +	unsigned long flags;
>>
>> +	mem_cgroup_begin_update_page_stat(page,&locked,&flags);
>>   	if (mapping) {
>>   		struct backing_dev_info *bdi = mapping->backing_dev_info;
>>   		unsigned long flags;
>> @@ -2272,6 +2282,8 @@ int test_set_page_writeback(struct page *page)
>>   	}
>>   	if (!ret)
>>   		account_page_writeback(page);
>> +
>> +	mem_cgroup_end_update_page_stat(page,&locked,&flags);
>>   	return ret;
>>
>>   }
> Where is the MEM_CGROUP_STAT_FILE_WRITEBACK increased?
>

It's in account_page_writeback().

  void account_page_writeback(struct page *page)
  {
+	mem_cgroup_inc_page_stat(page, MEM_CGROUP_STAT_FILE_WRITEBACK);
  	inc_zone_page_state(page, NR_WRITEBACK);
  }


There isn't a unified interface to dec/inc writeback accounting, so
I just follow that.
Maybe we can rework account_page_writeback() to also account
dec in?


Thanks,
Sha
