From: brookxu <brookxu.cn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/2] mem_cgroup: optimize the atomic count of
 wb_completion
Date: Fri, 24 Sep 2021 21:02:52 +0800
Message-ID: <03145735-7764-4cd4-e15b-60402f4b447e@gmail.com>
References: <1632465983-30525-1-git-send-email-brookxu.cn@gmail.com>
 <YU2boTZhfbo0h/Xi@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=0k4GidOpDOZlh4Z8G1WDVmPhA4Roxd0DMwZbEhyIkW0=;
        b=HmA3vYJrpvO5HCGcY/nOKAYXKJu2tMpAza2IwZBLmiwaBi3bpCiqGsRD2YiJi0Wpqd
         HQxVniQ+PdUJ/RcQQCVgacoFTkaDXsyLkbZ+huAdUO3/QrK756amHJ17LFNDSGW3M6Hf
         pr74o52t++xDu6/0SgJAwWwOuFtCGZzhpKHMCdt9rPK2l9t1f1Q0paQk1c6tjmZbW6Qo
         Fu+3/LqZIprNu82Ub/Appl8ZvLQjaOigNzq+sFA9+BIo4QKiqmEoJCwpIXYe9oX4pCG9
         RNPJPnUKD8MtfuCabWGyYSveEl1ShulzpiXzOk9zZcQsNdyftKW76tGLtf2BG1OFoGbO
         AUgQ==
In-Reply-To: <YU2boTZhfbo0h/Xi-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Thanks for your time.

Michal Hocko wrote on 2021/9/24 17:34:
> On Fri 24-09-21 14:46:22, brookxu wrote:
>> From: Chunguang Xu <brookxu-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>
>>
>> In order to track inflight foreign writeback, we init
>> wb_completion.cnt to 1. For normal writeback, this cause
>> wb_wait_for_completion() to perform meaningless atomic
>> operations. Since foreign writebacks rarely occur in most
>> scenarios, we can init wb_completion.cnt to 0 and set
>> frn.done.cnt to 1. In this way we can avoid unnecessary
>> atomic operations.
> 
> Does this lead to any measurable differences?

I created multiple cgroups that performed IO on multiple disks, 
then flushed the cache with sync command, and no measurable
differences have been observed so far.

> 
