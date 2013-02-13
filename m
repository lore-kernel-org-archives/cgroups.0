From: Greg Thelen <gthelen@google.com>
Subject: Re: [PATCH] memcg: Add memory.pressure_level events
Date: Wed, 13 Feb 2013 07:41:04 -0800
Message-ID: <xr93sj50z0fj.fsf@gthelen.mtv.corp.google.com>
References: <20130211000220.GA28247@lizard.gateway.2wire.net>
	<xr9338x01zpw.fsf@gthelen.mtv.corp.google.com>
	<20130213071503.GA20543@lizard.gateway.2wire.net>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=x-received:from:to:cc:subject:references:date:in-reply-to
         :message-id:user-agent:mime-version:content-type;
        bh=Rt7BsH55CXxAU2o84neeNsjZ3AqqhADSikWFWtplMN0=;
        b=FgTAV8jiLNyT1v6TeNkuFQ4VmUW6BWYXE3wrjX3HBsqWL+7c9+J8lKVLeOmXpt73Hv
         6lcnY1yt8PjPH1bS+T0mdaUTJC3yxvQd4TecjxBoqcbll3SKPW11pGmWmAvszvjlG60v
         iUbkR9mkbAMVJjWf2dhOztceaDBxQIWxLYTcX2vfgIlT3adr0GkN0Lu2GVvmiaOWjtQZ
         ZSuI5HpIxwutJBj3wilLGAh3nmb3TmCpmvFjkk7cTC90fLxHbhw/04QucbfRl0bYQbtS
         dpXek3S3EW2N4/i7xa2qjZIEgQoE+yZi9HQshnl/nfnS9YKDkB/yN92YvAk9/0gfOQ15
         fO2Q==
In-Reply-To: <20130213071503.GA20543@lizard.gateway.2wire.net> (Anton
	Vorontsov's message of "Tue, 12 Feb 2013 23:15:03 -0800")
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Anton Vorontsov <anton@enomsg.org>
Cc: cgroups@vger.kernel.org, Tejun Heo <tj@kernel.org>, David Rientjes <rientjes@google.com>, Pekka Enberg <penberg@kernel.org>, Mel Gorman <mgorman@suse.de>, Glauber Costa <glommer@parallels.com>, Michal Hocko <mhocko@suse.cz>, "Kirill A. Shutemov" <kirill@shutemov.name>, Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, Luiz Capitulino <lcapitulino@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Leonid Moiseichuk <leonid.moiseichuk@nokia.com>, KOSAKI Motohiro <kosaki.motohiro@gmail.com>, Minchan Kim <minchan@kernel.org>, Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>, John Stultz <john.stultz@linaro.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org, patches@linaro.org, kernel-team@android.com

On Tue, Feb 12 2013, Anton Vorontsov wrote:

> Hi Greg,
>
> Thanks for taking a look!
>
> On Tue, Feb 12, 2013 at 10:42:51PM -0800, Greg Thelen wrote:
> [...]
>> > +static bool vmpressure_event(struct vmpressure *vmpr,
>> > +			     unsigned long s, unsigned long r)
>> > +{
>> > +	struct vmpressure_event *ev;
>> > +	int level = vmpressure_calc_level(vmpressure_win, s, r);
>> > +	bool signalled = 0;
>> s/bool/int/
>
> Um... I surely can do this, but why do you think it is a good idea?

Because you incremented signalled below.  Incrementing a bool seems
strange.  A better fix would be to leave this a bool and
s/signaled++/signaled = true/ below.

>> > +
>> > +	mutex_lock(&vmpr->events_lock);
>> > +
>> > +	list_for_each_entry(ev, &vmpr->events, node) {
>> > +		if (level >= ev->level) {
>> > +			eventfd_signal(ev->efd, 1);
>> > +			signalled++;
>> > +		}
>> > +	}
>> > +
>> > +	mutex_unlock(&vmpr->events_lock);
>> > +
>> > +	return signalled;

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
