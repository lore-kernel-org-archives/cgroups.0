From: Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cgroup: fix lockdep warning for event_control
Date: Wed, 28 Nov 2012 13:33:11 -0800
Message-ID: <xr93hao9ifag.fsf@gthelen.mtv.corp.google.com>
References: <1354133742-22175-1-git-send-email-gthelen@google.com>
	<20121128210719.GB24683@htj.dyndns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version:content-type;
        bh=MV5qHrUtU9AA8ojkQnMvq+HX4xlPfJ1nxkuB5W3oKSo=;
        b=ONXBbVWFfuyiATAVfwSOx1iB0nqZVcXG1e7PdgJlIoP8X73tMMUXN9UVz7+m/NtF9w
         5LI64JUqTe7D7zC7WzVYPlQ9rxBWNcHTIpYpch0KYo3RLjNB3+QAYE7VCEKUp3YtHmD/
         K/wbd9hekdFuDtQbjnAUQmKIiDyT9eH796nRMts+L99lfZrfN30/fmxmiWUuqX9kbL4p
         Jk5zYFZx5n6b6jSDRc3z0Zuqf456JIsvcuH4VFXy8potdyHm2Izi/ZlSazvZFrWDk2Go
         2xY/h2OXLlh8gR5VIhou3es7IbpzyAZpaLNdahu30vHZxrTKzAzBYVyFXXgwKHWT+dli
         ep6A==
In-Reply-To: <20121128210719.GB24683-Gd/HAXX7CRxy/B6EtB590w@public.gmane.org> (Tejun Heo's message of
	"Wed, 28 Nov 2012 13:07:19 -0800")
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Aaron Durbin <adurbin-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On Wed, Nov 28 2012, Tejun Heo wrote:

> Hello, Greg.
>
> On Wed, Nov 28, 2012 at 12:15:42PM -0800, Greg Thelen wrote:
>> @@ -4276,6 +4276,7 @@ static int cgroup_destroy_locked(struct cgroup *cgrp)
>>  	DEFINE_WAIT(wait);
>>  	struct cgroup_event *event, *tmp;
>>  	struct cgroup_subsys *ss;
>> +	struct list_head tmp_list;
>
> LIST_HEAD(tmp_list);
>
>>  
>>  	lockdep_assert_held(&d->d_inode->i_mutex);
>>  	lockdep_assert_held(&cgroup_mutex);
>> @@ -4330,16 +4331,20 @@ static int cgroup_destroy_locked(struct cgroup *cgrp)
>>  	/*
>>  	 * Unregister events and notify userspace.
>>  	 * Notify userspace about cgroup removing only after rmdir of cgroup
>> -	 * directory to avoid race between userspace and kernelspace
>> +	 * directory to avoid race between userspace and kernelspace. Use
>> +	 * a temporary list to avoid a deadlock with cgroup_event_wake(). Since
>> +	 * cgroup_event_wake() is called with the wait queue head locked,
>> +	 * remove_wait_queue() cannot be called while holding event_list_lock.
>>  	 */
>>  	spin_lock(&cgrp->event_list_lock);
>> -	list_for_each_entry_safe(event, tmp, &cgrp->event_list, list) {
>> +	list_replace_init(&cgrp->event_list, &tmp_list);
>
> list_splice_init();
>
> would be more conventional, I think.

I used list_replace_init() because it avoided unnecessary init of
tmp_list.  But I have no objection to list_splice_init().  I'll repost
with list_splice_init().

>> +	spin_unlock(&cgrp->event_list_lock);
>> +	list_for_each_entry_safe(event, tmp, &tmp_list, list) {
>>  		list_del(&event->list);
>
> Maybe convert this to list_del_init() while at it?

I assume this isn't technically required, but defensive.  Seems like we
should also convert the list_del(&event->list) in cgroup_event_wake()
for consistency.  I'll send these in separate patch.

>>  		remove_wait_queue(event->wqh, &event->wait);
>>  		eventfd_signal(event->eventfd, 1);
>>  		schedule_work(&event->remove);
>>  	}
>> -	spin_unlock(&cgrp->event_list_lock);
>
> Thanks.
