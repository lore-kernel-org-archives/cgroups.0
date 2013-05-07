From: Sha Zhengju <handai.szj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 3/3] memcg: replace memparse to avoid input overflow
Date: Tue, 7 May 2013 23:55:04 +0800
Message-ID: <CAFj3OHVWQeB8D-6mVFBb+P4a7nyfLbBCx5ChtVmKZoL7M2_xoQ@mail.gmail.com>
References: <1367768681-4451-1-git-send-email-handai.szj@taobao.com>
	<20130507141208.GD9497@dhcp22.suse.cz>
	<51891816.806@oracle.com>
	<20130507151508.GF9497@dhcp22.suse.cz>
	<51891DF6.6060007@oracle.com>
	<20130507154814.GG9497@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:x-received:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type;
        bh=3QVdAm8DrnknPeqQzxLeoXQut79iFQegZYBfP7U5cQA=;
        b=x6dtSnZqR8gNQangWZcqGplbUBq4GdrSLdfpZMo+VJcmolkdF8APk1+Jd6/G8h8Dmn
         zpUiJafKFeXjhNk9Xajqfd2JSwuK7KGLnVlWiK9FDZ32cGywHo0NphOk6QNmOx8LUc79
         nLX445Qd2M9lBlAHOfmbqwf1Mhqz2kgZzOcnxaTU2CVIZM37hYpolv5Wys9hsjP2RQ36
         VcW4rWyKFVLxWXA/haw1OG+mZEOLByvSg6ZXDcXe9JtdImHFuiLGOYLUfxP+AzwgqQio
         GHd8rNQ4wZgwfrbmn4Lff7YxLVERw13WDxzegCXmqZSUht4fMHEoNEZs3pdRJvS5C2je
         uUKQ==
In-Reply-To: <20130507154814.GG9497-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: Jeff Liu <jeff.liu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Daisuke Nishimura <nishimura-YQH0OdQVrdy45+QrQBaojngSJqDPrsil@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>

On Tue, May 7, 2013 at 11:48 PM, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org> wrote:
> On Tue 07-05-13 23:29:58, Jeff Liu wrote:
>> On 05/07/2013 11:15 PM, Michal Hocko wrote:
>> > On Tue 07-05-13 23:04:54, Jeff Liu wrote:
>> >> On 05/07/2013 10:12 PM, Michal Hocko wrote:
>> >>> On Sun 05-05-13 23:44:41, Sha Zhengju wrote:
>> >>>> memparse() doesn't check if overflow has happens, and it even has no
>> >>>> args to inform user that the unexpected situation has occurred. Besides,
>> >>>> some of its callers make a little artful use of the current implementation
>> >>>> and it also seems to involve too much if changing memparse() interface.
>> >>>>
>> >>>> This patch rewrites memcg's internal res_counter_memparse_write_strategy().
>> >>>> It doesn't use memparse() any more and replaces simple_strtoull() with
>> >>>> kstrtoull() to avoid input overflow.
>> >>>
>> >>> I do not like this to be honest. I do not think we should be really
>> >>> worried about overflows here. Or where this turned out to be a real
>> >>> issue?
>> >> Yes. e.g.
>> >> Without this validation, user could specify a big value larger than ULLONG_MAX
>> >> which would result in 0 because of an overflow.  Even worse, all the processes
>> >> belonging to this group will be killed by OOM-Killer in this situation.
>> >
>> > I would consider this to be a configuration problem.
>> It mostly should be a problem of configuration.
>> >
>> >>> The new implementation is inherently slower without a good
>> >>> reason.
>> >> In talking about this, I also concerned for the overhead as per an offline
>> >> discussion with Sha when she wrote this fix.  However, can we consider it to be
>> >> a tradeoff as this helper is not being used in any hot path?
>> >
>> > what is the positive part of the trade off? Fixing a potential overflow
>> > when somebody sets a limit to an unreasonable value?
>> I suppose it to be a defense for unreasonable value because this issue
>> is found on a production environment for an incorrect manipulation, but
>> it's up to you.
>
> I _really_ do not want to punish everybody just because of somthing that
> is a configuration issue.

Okay, Let's lay it aside for the moment.  Thank you!

>
>>
>> Thanks,
>> -Jeff
> --
> Michal Hocko
> SUSE Labs
> --
> To unsubscribe from this list: send the line "unsubscribe cgroups" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



--
Thanks,
Sha
