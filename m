From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 10/13] cpuset: make CPU / memory hotplug propagation
	asynchronous
Date: Mon, 7 Jan 2013 08:42:06 -0800
Message-ID: <20130107164206.GG3926@htj.dyndns.org>
References: <1357248967-24959-1-git-send-email-tj@kernel.org>
	<1357248967-24959-11-git-send-email-tj@kernel.org>
	<50E935D5.4040402@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20120113;
	h=x-received:sender:date:from:to:cc:subject:message-id:references
	:mime-version:content-type:content-disposition:in-reply-to
	:user-agent; bh=61oyj/4zkapxURIGg4lhkJTwZ9tKu5PVuzplEtra3SQ=;
	b=lj29oT84Vsi8D/vyAAr+ut81AdJXm8St3i3VxErAMSE0gmOGjqzzHgpiQBHSjAqmLh
	1KwSr0/miUATDYeq5UfOs2lNnDvqGmb/xT3hfOQmtf//Jb/o+gulGGOOOGXUUErJIq06
	XLuj74YAFv5PxTdbagXvILNbjxVcGC1VZ1FY0R8IF0Z/77VuVCxnciTdndmXhREz7oMh
	MFxjbTWsFlVzL3UmHiog+ysXdQZSWeDn/DGJFG1Xd0FlQSyWdRbsgJW8/zdy9lQ/QTRI
	bYy9QPYzGrOzDU3AxKIed1U3uiP8+w80+R3//Ow8T0Dk2l0/FlvRxyJyLdIUiz+4Occ7
	gOxQ==
Content-Disposition: inline
In-Reply-To: <50E935D5.4040402-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
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
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: paul-inf54ven1CmVyaH7bEyXVA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org

On Sun, Jan 06, 2013 at 04:29:09PM +0800, Li Zefan wrote:
> > +static void schedule_cpuset_propagate_hotplug(struct cpuset *cs)
> > +{
> > +	/*
> > +	 * Pin @cs.  The refcnt will be released when the work item
> > +	 * finishes executing.
> > +	 */
> > +	if (!css_tryget(&cs->css))
> > +		return;
> > +
> > +	/*
> > +	 * Queue @cs->empty_cpuset_work.  If already pending, lose the css
> 
> cs->hotplug_work

Thanks.  Patch updated.

-- 
tejun
