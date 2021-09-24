From: "brookxu.cn" <brookxu.cn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/2] mem_cgroup: optimize the atomic count of
 wb_completion
Date: Fri, 24 Sep 2021 23:21:19 +0800
Message-ID: <df9c2c8e-bc28-d929-c2e1-18f6f91ca336@gmail.com>
References: <1632465983-30525-1-git-send-email-brookxu.cn@gmail.com>
 <YU2boTZhfbo0h/Xi@dhcp22.suse.cz>
 <03145735-7764-4cd4-e15b-60402f4b447e@gmail.com>
 <YU3aT7i2vBNxewam@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=IWRHE1IksF7N6nES1jMNs1UVooFjxKrNMdCiqYqknKk=;
        b=UDZUjjkUoxBjfAQ4BcGh4zDS6QNQMedJm0c91MDS4B53lfGBP9hGwV9ieWJBUDrTmP
         qiSULABKykEaSMPub+/ykJ+xFAhIFg33dF5IfSUeIwMU+fgKn+dVt5+345rOe/v7v9vF
         yrZO+2N2Gy+eoy5nrHcyzePL3ShWtfm6R2q2LyfMwe9kW1TetvHPgCs4+gQUZZ6kIAyV
         GHHeXQlN9PrCyn5NNn2SGwoxTONbk5Pb6XSBIJ7AwMOTb5mzGqr/GDHJU+NZFZLXTW74
         QzV+R1/l01RJacrzEcTvnwVL5MAhxkawdgzfhBj5BiggvEesd1jjuKbgKKfr6PegH/9s
         qeyg==
In-Reply-To: <YU3aT7i2vBNxewam-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Thanks for your time.

On 2021/9/24 10:01 PM, Michal Hocko wrote:
> On Fri 24-09-21 21:02:52, brookxu wrote:
>> Thanks for your time.
>>
>> Michal Hocko wrote on 2021/9/24 17:34:
>>> On Fri 24-09-21 14:46:22, brookxu wrote:
>>>> From: Chunguang Xu <brookxu-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>
>>>>
>>>> In order to track inflight foreign writeback, we init
>>>> wb_completion.cnt to 1. For normal writeback, this cause
>>>> wb_wait_for_completion() to perform meaningless atomic
>>>> operations. Since foreign writebacks rarely occur in most
>>>> scenarios, we can init wb_completion.cnt to 0 and set
>>>> frn.done.cnt to 1. In this way we can avoid unnecessary
>>>> atomic operations.
>>>
>>> Does this lead to any measurable differences?
>>
>> I created multiple cgroups that performed IO on multiple disks,
>> then flushed the cache with sync command, and no measurable
>> differences have been observed so far.
> 
> OK, so why do we want to optimize this code?

Just a optimization point discovered during the diagnosis, no
behavior change.

> 
