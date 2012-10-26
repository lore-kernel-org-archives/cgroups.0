From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 1/1] freezer: change ptrace_stop/do_signal_stop to use
	freezable_schedule()
Date: Fri, 26 Oct 2012 10:52:58 -0700
Message-ID: <20121026175258.GV11442@htj.dyndns.org>
References: <20121022211317.GD5951@atj.dyndns.org>
	<20121023153919.GA16201@redhat.com>
	<20121024185710.GA12182@atj.dyndns.org>
	<20121025163941.GA3801@redhat.com>
	<20121025163959.GB3801@redhat.com>
	<20121025171812.GE11442@htj.dyndns.org>
	<20121025173433.GA7650@redhat.com>
	<20121025173632.GI11442@htj.dyndns.org>
	<20121026174545.GA21639@redhat.com>
	<20121026174606.GB21639@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20120113;
	h=sender:date:from:to:cc:subject:message-id:references:mime-version
	:content-type:content-disposition:in-reply-to:user-agent;
	bh=wMSjtrXVBaOcotFBu+A1Hb89cOrPFFQ49/kQ6mc+YM4=;
	b=iPZ7HnJEjE/zIt7tVOuoFr5VD0mx1oN40FUkAAe3+y93cJQc20qunIICAHCeDyvA8S
	WiAfAEb2Me7Ze9qCdnUrNqNqTYM7RFQbfca8TUb5LhbuBTl+/jEOlnEJEmkdEi8wNTED
	Uk2fexsWmNf1OyjvfV0nN7TzDkLzLI7vLdfq+SyBls5rfEMJab6ePv52akBPtPlvv7ja
	IEFgz95558F9utGXCf1Zaf+gvYByMkZo8ffs9e6qJ3ODLn6rxiso25kqG133m5yM4pPk
	bHrHkuczPrEyM3Tf+M4vO/4H2OhYWAQTJUP7NQOB7S3NikXMLOurPxCWcCGQ7hmQnyL9
	EoPQ==
Content-Disposition: inline
In-Reply-To: <20121026174606.GB21639-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
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
To: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, rjw-KKrjLPT3xs0@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, Oct 26, 2012 at 07:46:06PM +0200, Oleg Nesterov wrote:
> try_to_freeze_tasks() and cgroup_freezer rely on scheduler locks
> to ensure that a task doing STOPPED/TRACED -> RUNNING transition
> can't escape freezing. This mostly works, but ptrace_stop() does
> not necessarily call schedule(), it can change task->state back to
> RUNNING and check freezing() without any lock/barrier in between.
> 
> We could add the necessary barrier, but this patch changes
> ptrace_stop() and do_signal_stop() to use freezable_schedule().
> This fixes the race, freezer_count() and freezer_should_skip()
> carefully avoid the race.
> 
> And this simplifies the code, try_to_freeze_tasks/update_if_frozen
> no longer need to use task_is_stopped_or_traced() checks with the
> non trivial assumptions. We can rely on the mechanism which was
> specially designed to mark the sleeping task as "frozen enough".
> 
> v2: As Tejun pointed out, we can also change get_signal_to_deliver()
> and move try_to_freeze() up before 'relock' label.
> 
> Signed-off-by: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Looks good to me. :)

 Acked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Rafael, sorry that this one doesn't have pm cc'd but can you please
pick up this one too?

Thanks a lot.

-- 
tejun
