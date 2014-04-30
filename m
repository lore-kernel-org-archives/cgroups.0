From: Raghavendra KT <raghavendra.kt-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCHSET cgroup/for-3.15] cgroup: implement unified hierarchy
Date: Wed, 30 Apr 2014 16:27:51 +0530
Message-ID: <CAC4Lta0qd2vW4ENSOpzK+0i06MorzfmsZZZuW9xUtpZ_gWA9gA@mail.gmail.com>
References: <1395974461-12735-1-git-send-email-tj@kernel.org>
	<20140414154556.GA9552@redhat.com>
	<20140414175236.GB15249@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20120113;
	h=mime-version:sender:in-reply-to:references:date:message-id:subject
	:from:to:cc:content-type;
	bh=H8HTrOATkJkx9dCOxKTF2wd1nFyy9mzkUgC3eFtzE4Y=;
	b=CtGrDe2bJh2hPgvBb5BCKaIjRHOn3bWA4dAK+Ej61h9AePcY77JOGaGBv/f3YE/wJ6
	kMFRcFdJXKucKGLfbiYSNEhWhIuhmb0cMSTFwFaiul70OHDBSP/JA5vxCdSZYchbKvyl
	oesy6dtaY2tN27OCga35UjMRaZ+d/MLylUZw9J+5V9gdK1DRRKOHeD64s76e7pgvyXtl
	KfeZ3BQU+rDjVnKDo9GP9+ZHs6h4e7up6ZD0tmq46XX41vGXMFE6uB6kRaJ+m9gFKLMG
	6cNVMeVly0s2o8zmRJXlcalhQj7qdBOvdcZCvK/oq3gyB80w0HVyQWnLnJyOWQjpo73Q
	47Iw==
In-Reply-To: <20140414175236.GB15249-Gd/HAXX7CRxy/B6EtB590w@public.gmane.org>
List-Id: <cgroups.vger.kernel.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>, 
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

On Mon, Apr 14, 2014 at 11:22 PM, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>> How does this work for root's tasks now? Given that task can only be
>> in leaf cgroups, that means tasks can't be in / cgroup (If one wants
>> to create some cgroups). Does that mean / will be empty and init system
>> need to setup things right.
>
> Root is exempt from the restriction.  Root has always been special
> anyway.
>

(I do not wish to Hijack this thread,  but found a relevant context
 here to initiate discussion.  But would discuss in a separate thread
once I get a positive go on the topic)

Hi Tejun,

For some controllers like cpuset, when we have exclusive_cpu is set,
what about having a knob in the cpuset controller
to move the task to non-root (when option is set).

Because all the way along, though we have freedom to make the cpusets
exclusive and move tasks (say VMs) into them,
making sure they do not interfere with each other, we can not prevent
the other tasks spawned in a system eating into cpus of
exclusive cpuset since they go to root automatically.

Do you think having a knob, to make sure new tasks spawned go to say a
default  directory under root makes sense?

 I understand that we could easily have a userspace script which could
achieve intended goal, but kernel solution
 would really make the exclusive cpusets have exclusive access to cpus
it should have.

(I also have a POC implemented for pre-unified hierarchy tree and
understand some bit of complications involved in that and
understand that we should not have complex policies in kernel for e.g.
filtering tasks based on patterns etc..).
