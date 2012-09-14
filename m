From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC] cgroup TODOs
Date: Fri, 14 Sep 2012 15:06:07 -0700
Message-ID: <20120914220607.GX17747@google.com>
References: <20120913205827.GO7677@google.com>
	<CAPhKKr8wDLrcWHLTRq1M7gU_6CGNxzzF83zJo2WZ5vrY7h8Qyw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20120113;
	h=sender:date:from:to:cc:subject:message-id:references:mime-version
	:content-type:content-disposition:in-reply-to:user-agent;
	bh=LnP1PV86TCmLKF5qhCtLvn0BzNPkEmKRVIJBOUlvnBk=;
	b=nHtCY8kzR2+cQB1gWzH90dW02Qws7zIHT5x/84dBrfLO7+KJ/dyaFS5dauxiUyNXcq
	6M4dcGOHcwRAQHzz7KPsbh+F5YmZGuqgbHlnwhu/geLKazwgrntXgE7XLvkBVVTiN8Mm
	9JFouNgXBBIWVEcJ22VAEa1MdVWB1dMpAqP60emFLUhDGSRpVsrPDSdYEx5rT7OsXu6V
	DRMKWoer2vaBmNy0CLJ08J5m8BLjmlo2GokFxpmDOMs7uua/05OIzr8K7m3pAS7ctPww
	HyhC47M5rhvg3yMQZJa6lNBWIgnrCxAvyJxA8xUk5gg2kApovXo9FFT6i2kKiw1fD2Vc
	8+IQ==
Content-Disposition: inline
In-Reply-To: <CAPhKKr8wDLrcWHLTRq1M7gU_6CGNxzzF83zJo2WZ5vrY7h8Qyw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
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
To: Dhaval Giani <dhaval.giani-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Neil Horman <nhorman-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org>, "Serge E. Hallyn" <serue-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Paul Mackerras <paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Arnaldo Carvalho de Melo <acme-f8uhVLnGfZaxAyOMLChx1axOck334EZe@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Thomas Graf <tgraf-G/eBtMaohhA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Hello,

On Fri, Sep 14, 2012 at 06:03:16PM -0400, Dhaval Giani wrote:
> >
> >   * Sort & unique when listing tasks.  Even the documentation says it
> >     doesn't happen but we have a good hunk of code doing it in
> >     cgroup.c.  I'm gonna rip it out at some point.  Again, if you
> >     don't like it, scream.
> 
> I think some userspace tools do assume the uniq bit. So if we can
> preserve that, great!

Can you point me to those?  If there are users depending on it, I
won't break it, at least for now, but I at least wanna know more about
them.

Thanks.

-- 
tejun
