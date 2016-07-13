From: Topi Miettinen <toiwoton-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] capabilities: audit capability use
Date: Wed, 13 Jul 2016 06:52:06 +0000
Message-ID: <687b82c6-0e66-0ff1-30f1-a1d60f40f624@gmail.com>
References: <1468235672-3745-1-git-send-email-toiwoton@gmail.com>
 <20160711170711.GB3337@htj.duckdns.org>
 <683cdbb9-c414-07c7-16d3-41c4138ddf8d@gmail.com>
 <20160712145936.GH3190@htj.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=subject:to:references:cc:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=HwYOqB9OAIuGJlndnsHL5F2GD/tuo06B4Z8hoMnUraI=;
        b=UV8mHMQvJKXdch/CE0U9+e8hs3v/ezjvz426IDZsGY8skwKwgVTm3TFZcujeH0ETgx
         I1UWTzN1KraTCKFt0kAmQxn7RSa46hhSUjnIKiB4sbtYGluWM54bZnfez3Iqh//JAnR5
         otYDITD8XBdYUrPz1t5q6y1yrRFd+uwa0nWhXXrFbd/zdi246/CLG/z3hJg+jLzKMVIc
         Uf8rhcGf6huSr6h8B010ZELEZncg1RImxMCzI98n3Lgk9s8xF2J9BZ91Q/YzQWXl4mWY
         OVPgZEx9Wwh5Ok87hu2yWB4O6upM4FWxDtYF9luxtswiUJvWyZFBIdYr/3meGDFAQtnt
         vLnQ==
In-Reply-To: <20160712145936.GH3190-piEFEHQLUPpN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, pmladek-IBi9RG/b67k@public.gmane.org, luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, Paul Moore <paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org>, Eric Paris <eparis-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, "moderated list:AUDIT SUBSYSTEM" <linux-audit-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "open list:CONTROL GROUP (CGROUP)" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "open list:CAPABILITIES" <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On 07/12/16 14:59, Tejun Heo wrote:
> On Mon, Jul 11, 2016 at 07:47:44PM +0000, Topi Miettinen wrote:
>> It's really critical to be able to associate a task in the logs to
>> cgroups which were valid that time. Or can we infer somehow what cgroups
> 
> When is "that time"?  Without logging all operations, this is
> meaningless.
> 
>> a task was taking part, long time after task exit? Perhaps task cgroup
>> membership changes and changes in available cgroups should be logged too?
>>
>> Some kind of cgroup IDs could be logged instead of long paths. Then
>> these IDs should be reliably resolvable to paths offline somehow.
> 
> I don't think that's doable.  That pretty much requires the kernel to
> remember paths of all past cgroups.

That's a show stopper for audit approach for getting helpful information
for configuration. I'll try something different, probably cgroupstats.

-Topi

> 
>> How usual migrations between cgroups are? Why would a task ever move
>> from (say) systemd/system.slice/smartd.service to anywhere else?
> 
> In most cases, they won't move once set up initially but that's not
> the point of audit subsystem.  Logging this once one exit isn't gonna
> help anything for auditing the system.
> 
> Thanks.
> 
