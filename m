From: Sha Zhengju <handai.szj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 7/7] memcg: print more detailed info while memcg oom happening
Date: Wed, 04 Jul 2012 19:20:49 +0800
Message-ID: <4FF42711.50303@gmail.com>
References: <1340880885-5427-1-git-send-email-handai.szj@taobao.com> <1340881609-5935-1-git-send-email-handai.szj@taobao.com> <4FF3FED6.9010700@jp.fujitsu.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        bh=2jrv1AFmcozevJSzxQuR90AC630qvzUpTd4ezO1FXKM=;
        b=TXNQK/qChyDv1FlmmLwC2QqA1nK8LbnB1k3cFz6FjxOzuxpahtfxBQcAuLWsNdVvgF
         em73hes9HNLFQnuCPJvx1gfvJmfgAz9+EUT42RQA/m1VXnsgJ3C1Z/6xXXJ7XubYLXC0
         FgGVyAuuuDGTotbXp1q4LZAidkBk+cCXKmyytooBS4X2Hzd/J6zsWEwWJLloCIU/4hOk
         pnpDsOECgP3H0bUyrjSyW7XZUhkogtmh7IiWbwaCtALoxCjlh6qZAIAj6hZZNG/eqa2x
         tZCgj3IKMyNT2C/zCKtbs5vkZaU0UCdxAqgTk8An1o7aueuQnsgwRRWEDH8V2MCMQkGD
         Djdw==
In-Reply-To: <4FF3FED6.9010700-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>

On 07/04/2012 04:29 PM, Kamezawa Hiroyuki wrote:
> (2012/06/28 20:06), Sha Zhengju wrote:
>> From: Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>
>>
>> While memcg oom happening, the dump info is limited, so add this
>> to provide memcg page stat.
>>
>> Signed-off-by: Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>
> Could you split this into a different series ?
> seems good to me in general but...one concern is hierarchy handling.
>
> IIUC, the passed 'memcg' is the root of hierarchy which gets OOM.
> So, the LRU info, which is local to the root memcg, may not contain any good
> information. I think you should visit all memcg under the tree.
>
Yes, you're right!
I did not handle hierarchy here, and just now I make a test case to
prove this.
I'll split it to another series later.

Thanks for reviewing!


Thanks,
Sha
