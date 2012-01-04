From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Subject: Re: [PATCH 1/2] memcg: root_mem_cgroup makes static
Date: Wed, 4 Jan 2012 12:34:39 -0500
Message-ID: <CAHGf_=o-mBAZxAW=vHSKKBCGqtzc+ooXrc9+vHvPoo_t4A9Chg@mail.gmail.com>
References: <1325633632-9978-1-git-send-email-kosaki.motohiro@gmail.com> <20120104084611.GA12581@tiehlicka.suse.cz>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        bh=sNbc4CgSyuLfOpAzfIDUP8WciJMS7btZaLHW1K6gVoQ=;
        b=e1WISyURL/UO8rFz5bRJALqi1NDYUY6Ai1/5RbdYY+RQ/gsi0X9BwSzJDY2ulqHycP
         yLdfCO6tKejnrOAPsXwOXyJ+tZCEIT2MTx7s+hRJp5OSAOGx4evjHBnKEeQSQcUMKax/
         FrI9e3qk3IH8n8/PACWVIbGLS2CvT6qYLghuo=
In-Reply-To: <20120104084611.GA12581@tiehlicka.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@suse.cz>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org

2012/1/4 Michal Hocko <mhocko@suse.cz>:
> On Tue 03-01-12 18:33:51, kosaki.motohiro@gmail.com wrote:
>> From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
>>
>> root_mem_cgroup is only referenced from memcontrol.c. It should be static.
>
> This has been already posted by Kirill
> https://lkml.org/lkml/2011/12/23/292

Oops. I haven't noticed.

Thank you, Michal!

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
