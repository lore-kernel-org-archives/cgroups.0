From: Sha Zhengju <handai.szj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH V3 6/8] memcg: Don't account root_mem_cgroup page statistics
Date: Sat, 5 Jan 2013 15:38:32 +0800
Message-ID: <CAFj3OHW2E_U9B0x0iNMQHkDXLLyLkF3Bz-KUDto3BcKHi6374g@mail.gmail.com>
References: <1356455919-14445-1-git-send-email-handai.szj@taobao.com>
	<1356456447-14740-1-git-send-email-handai.szj@taobao.com>
	<50DCF00B.5040100@jp.fujitsu.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:x-received:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type;
        bh=bjvo6AF8orlkQ6T7Ych8bouOeQ5u7Bcvt6Iwwiu56NA=;
        b=05nP+pwc6hb3g5rQW/jkJt2hZadJB1FfIVGvlUHeyDIX5RRnML3H3+OVn0pMpjDdsw
         8aeFOWcLxZol+bS+rvDHhWzR/JoISPOC97JTQQXAuqkK7GAsZKspeVSoQPfmoJu/cKUh
         n0LDS+v/bn/DCi1sEVQfFQrwGh8uF2RTGLlHCOtCF2mRCZm9m2MOV4UrvtrbmsAPpEwu
         LZCEo57kb+AfGROh/15eewBkZs6oPD3TW036x0oghpB6phiMFizpf9Ci8K9RXL4mMrOa
         igwCakC6Ew5rgT4hsVMmEejREnkmeQbkAfWb3SGToeWORphKj+WW9xvMbjL+ZmL2j1rO
         WiHg==
In-Reply-To: <50DCF00B.5040100-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org, Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>

On Fri, Dec 28, 2012 at 9:04 AM, Kamezawa Hiroyuki
<kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org> wrote:
> (2012/12/26 2:27), Sha Zhengju wrote:
>> From: Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>
>>
>> If memcg is enabled and no non-root memcg exists, all allocated pages
>> belongs to root_mem_cgroup and go through root memcg statistics routines
>> which brings some overheads. So for the sake of performance, we can give
>> up accounting stats of root memcg for MEM_CGROUP_STAT_FILE_MAPPED/FILE_DIRTY
>> /WRITEBACK and instead we pay special attention while showing root
>> memcg numbers in memcg_stat_show(): as we don't account root memcg stats
>> anymore, the root_mem_cgroup->stat numbers are actually 0. But because of
>> hierachy, figures of root_mem_cgroup may just represent numbers of pages
>> used by its own tasks(not belonging to any other child cgroup). So here we
>> fake these root numbers by using stats of global state and all other memcg.
>> That is for root memcg:
>>       nr(MEM_CGROUP_STAT_FILE_MAPPED) = global_page_state(NR_FILE_MAPPED) -
>>                                sum_of_all_memcg(MEM_CGROUP_STAT_FILE_MAPPED);
>> Dirty/Writeback pages accounting are in the similar way.
>>
>> Signed-off-by: Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>
>
> isn't it better to use mem_cgroup_is_root() call rather than
> direct comparison (memcg == root_mem_cgroup) ?
>

Okay, it's better to use the wrapper.

> Anyway, Ack to this approach.
>

Thanks for reviewing!


Regards,
Sha
