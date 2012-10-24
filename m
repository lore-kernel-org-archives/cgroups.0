From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 2/7] freezer: add missing mb's to freezer_count() and
 freezer_should_skip()
Date: Wed, 24 Oct 2012 14:57:10 -0400
Message-ID: <20121024185710.GA12182@atj.dyndns.org>
References: <1350426526-14254-1-git-send-email-tj@kernel.org>
 <1350426526-14254-3-git-send-email-tj@kernel.org>
 <20121022174404.GA21553@redhat.com>
 <20121022211317.GD5951@atj.dyndns.org>
 <20121023153919.GA16201@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=vP6/hJo5giHlnI74RCKj22lLDf+B1QNQZPjPWRCJ2sQ=;
        b=D3bdo8SMaXlY4qVEbNIfu2zP2F/mRoHyKeCR6S/AAQIji9btZNWMlUDo+LFlRBakx2
         QDjvUV87ib7xECHxnk+mEyOxDuwBxzytRtrnd1tMUDtqugb1CxzQvLZMWnK+zOKPb4P+
         gksfCcxJ7qRRGIVQs4JFFoI5QorGJkOJuf4UvFKTQggx/bCZeCLEo2LisbDCitc3DYj4
         xK544xcXqKEIq/WZM3opQ5jsIQXrLc9c3yRLkLGs+AfIKEAfHSmcDRNqSzZEnFHb4gA0
         JVwV9Ne08ZzN1G+PGdwf+QYF6/ib7IKQk8O7jgtlEycMtxl+DrAV2r7NCVm+3HV/GRVk
         +RHA==
Content-Disposition: inline
In-Reply-To: <20121023153919.GA16201-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: rjw-KKrjLPT3xs0@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello, Oleg.

On Tue, Oct 23, 2012 at 05:39:19PM +0200, Oleg Nesterov wrote:
> > Hmm....  Guess we should drop __ from set_current_state.
> 
> Yes.
> 
> Or we can change ptrace_stop() and do_signal_stop() to use freezer_do_not_count/
> freezer_count and remove task_is_stopped_or_traced() from update_if_frozen()
> and try_to_freeze_tasks(). But this means that do_signal_stop() will call
> try_to_freeze() twice, unless we add __freezer_count() which only clears
> PF_FREEZER_SKIP.

Ooh, I like this idea.  If we have a mechanism to mark a task "frozen
enough", it makes sense to use it universally.  As long as
try_to_freeze() invocation stays outside fast path, I don't think
invoking it twice really matters.  Can you please cook up a patch for
it?

Thanks.

--
tejun
