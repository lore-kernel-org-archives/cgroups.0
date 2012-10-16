From: Sha Zhengju <handai.szj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] oom, memcg: handle sysctl oom_kill_allocating_task while
 memcg oom happening
Date: Tue, 16 Oct 2012 18:41:41 +0800
Message-ID: <507D39E5.5010301@gmail.com>
References: <1350382328-28977-1-git-send-email-handai.szj@taobao.com> <507D34E3.3040705@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        bh=zxB/cyD9RwLbXrErilspZ8MqkFRsMXsXacDlfOZJWPw=;
        b=RAtRCJeA3uGFOL2JFk9eUQHI5Dce2kHDS7gB2yFKOsIANjASIA8G47uLddhUFgMTWq
         LIZeo9L6x5KSmy/855siGLNhCyfCcTX+AlNkCQqF/WJABngxuSMRc4xKwa45COkBScgo
         CXiC2p/SatqYzCciNx43MqVHi00S7JEKrqK8A4LEqCdk/L/qrSdMXfrUZa8MeZoo1i6g
         rn1wr9yi/7nlWGKq0oq1w/w9469Bw9Vkd/aOg6Iye67xosFVh0fqCxVpndSZYbLaQGdI
         NYByfAFKmwiz6f3HpWaIih4p7y5FCKkKiESNpE3QJGjJcEp266o9OsSPJ7YUiO9LyNdw
         5lRw==
In-Reply-To: <507D34E3.3040705-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Ni zhan Chen <nizhan.chen-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>

On 10/16/2012 06:20 PM, Ni zhan Chen wrote:
> On 10/16/2012 06:12 PM, Sha Zhengju wrote:
>> From: Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>
>>
>> Sysctl oom_kill_allocating_task enables or disables killing the 
>> OOM-triggering
>> task in out-of-memory situations, but it only works on overall 
>> system-wide oom.
>> But it's also a useful indication in memcg so we take it into 
>> consideration
>> while oom happening in memcg. Other sysctl such as panic_on_oom has 
>> already
>> been memcg-ware.
>
> Is it the resend one or new version, could you add changelog if it is 
> the last case?

Sorry, forget to mention that this patch is an updated one rebased on 
mhocko mm tree, since-3.6 branch.
The first one is on old kernel, please ignore it. :-)


Thanks,
Sha
