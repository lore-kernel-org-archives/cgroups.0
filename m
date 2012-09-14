From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC] cgroup TODOs
Date: Fri, 14 Sep 2012 12:49:50 -0700
Message-ID: <20120914194950.GQ17747@google.com>
References: <20120913205827.GO7677@google.com>
	<20120914180754.GF6221@redhat.com>
	<20120914185324.GI17747@google.com>
	<20120914192840.GG6221@redhat.com>
	<20120914194439.GP17747@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20120113;
	h=sender:date:from:to:cc:subject:message-id:references:mime-version
	:content-type:content-disposition:in-reply-to:user-agent;
	bh=h8oMRvcVbolasMl00bGLxPPbL12IMWxPKSs7cs+2mt8=;
	b=IppiFwoogV0mrjotz/Abetb/+2l0BXqpCqz4a5Gk+WLbUSOrspvcSCFkOHYZ3LVueP
	4TdJr8bTwraq7SLeMizD2xWXirmxO6QrQQtQt8dC46wwUViUsRZO/d5ESk7T0Wd1rZaQ
	r/9pv2yg097v2jhWg4ZCwg8ETQDZPzbad0dQVawNYMhxMjoUdjfIWphD6KGfcal3Q5IH
	1HVET/9h/jdyGzJpA2e84zvqEy25Z1vDvZz7RObZsJCOLoAIX0QzbUVGOLwh6Xo8T8DW
	83pBU/J6v3jWqdnSFWSbVA4jg/xXlkHTp3BRJq6PklEq9p9Bcg3lYmIfsu4r+iR5A9wI
	VynQ==
Content-Disposition: inline
In-Reply-To: <20120914194439.GP17747-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
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
To: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Neil Horman <nhorman-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org>, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Paul Mackerras <paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Arnaldo Carvalho de Melo <acme-f8uhVLnGfZaxAyOMLChx1axOck334EZe@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Thomas Graf <tgraf-G/eBtMaohhA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

On Fri, Sep 14, 2012 at 12:44:39PM -0700, Tejun Heo wrote:
> I think there currently is too much (broken) flexibility and intent to
> remove it.  That doesn't mean that removeing all flexibility is the
> right direction.  It inherently is a balancing act and I think the
> proposed solution is a reasonable tradeoff.  There's important
> difference between causing full overhead by default for all users and
> requiring some overhead when the use case at hand calls for the
> functionality.

That said, if someone can think of a better solution, I'm all ears.
One thing that *has* to be maintained is that it should be able to tag
a resource in such way that its associated controllers are
identifiable regardless of which task is looking at it.

Thanks.

-- 
tejun
