From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 6/6] cgroup: implement for_each_[builtin_]subsys()
Date: Mon, 24 Jun 2013 13:04:33 -0700
Message-ID: <20130624200433.GI1918@mtj.dyndns.org>
References: <1371864854-28364-1-git-send-email-tj@kernel.org>
	<1371864854-28364-7-git-send-email-tj@kernel.org>
	<51C82482.9020902@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20120113;
	h=sender:date:from:to:cc:subject:message-id:references:mime-version
	:content-type:content-disposition:in-reply-to:user-agent;
	bh=eG2emxt6+fmzB18/w7EmLkkxvvEXlY05Clyk8N6vGDI=;
	b=i0vl0GDsPndEo0a2mxi1+/1puxkc0ik2sS0H7nleVn7aKJ4/ydMl7jeOZOwYBf3Kga
	jfmrshPU8mgJy4hpeoSWmgubg6rPkyfZW8Yd6RR3shjvolLWFIINALNlWTf8W5Q0FtLr
	/FxR3weilmBckqG7A0a0y1zB6ytxYAysfzw596nVT1tbVI6vdhTdZLKcuTDv7eap1ZVN
	2+sHRYFEnTLgLK5WainJR5eXzK86MzReL+oRHZ4oXkY03haq4s7Tb6xcNOOs3vIDiDCO
	lcmRgxIp4UFveMLJDgM2/RR5BmJNHaFX9m9nNkYzfvrnxQ4dqDp4jrB458I9j0qZ+lZK
	wddQ==
Content-Disposition: inline
In-Reply-To: <51C82482.9020902-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
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
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org

On Mon, Jun 24, 2013 at 06:50:42PM +0800, Li Zefan wrote:
> > +/**
> > + * for_each_subsys - iterate all loaded cgroup subsystems
> > + * @ss: the iteration cursor
> > + * @i: the index of @ss, CGROUP_SUBSYS_COUNT after reaching the end
> > + */
> > +#define for_each_subsys(ss, i)						\
> 
> This should be called with cgroup_mutex held, so how about add a comment or
> a lock assert for it?

Will do.

> > +#define for_each_builtin_subsys(ss, i)					\
> > +	for ((i) = 0; (i) < CGROUP_BUILTIN_SUBSYS_COUNT &&		\
> > +	     (((ss) = cgroup_subsys[i]) || true); (i)++)
> 
> Why "true" is needed here? given ss can't be NULL.

Because the compiler doesn't know that and we want the compiler to
optimize out the conditional branch.

Thanks.

-- 
tejun
