From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v2 3/3] mm: memcontrol: recursive memory.low protection
Date: Thu, 13 Feb 2020 11:57:11 -0500
Message-ID: <20200213165711.GJ88887@mtj.thefacebook.com>
References: <20191219200718.15696-4-hannes@cmpxchg.org>
 <20200130170020.GZ24244@dhcp22.suse.cz>
 <20200203215201.GD6380@cmpxchg.org>
 <20200211164753.GQ10636@dhcp22.suse.cz>
 <20200212170826.GC180867@cmpxchg.org>
 <20200213074049.GA31689@dhcp22.suse.cz>
 <20200213135348.GF88887@mtj.thefacebook.com>
 <20200213154731.GE31689@dhcp22.suse.cz>
 <20200213155249.GI88887@mtj.thefacebook.com>
 <20200213163636.GH31689@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=/9pAJl5lwO/l/LEFjlIiSIPtfDfflLg/CjlywKeZ4W0=;
        b=pka2Qi2fbd4HXtA3HE9p7vhJ6JpjDs0dwsLG0U+e+THmClapZAuyNGAXaL5mEj5uQq
         3s/RQwhkHiv6KWwihYhaeNTXKGqk4U374R5+UjJXesDuYKEzBXCMXJCgEpQBMCxPnDCS
         5jowrfBMqUdowxvefJdPm6iqwb/LNFkrv5MZ/fBv4iTL2wrVypqI6oHgm2pS2mqSsPNE
         6UIq7Wkt1Rk9cPW8ee159csvhfNdZMOPWpZM95gXav8SFLtL7tgVPVfpE/Dp1ZoZynqn
         Hj8iF2bqUlyu9r5/ROJxIRGMnT4izUTycemTJT1HXfkqreQteC/5+FWT+wAUz7O43kK6
         ZQ4Q==
Content-Disposition: inline
In-Reply-To: <20200213163636.GH31689@dhcp22.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <guro@fb.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

Hello,

On Thu, Feb 13, 2020 at 05:36:36PM +0100, Michal Hocko wrote:
> AFAIK systemd already offers knobs to configure resource controls [1].

Yes, it can set up the control knobs as directed but it doesn't ship
with any material resource configurations or has conventions set up
around it.

> Besides that we are talking about memcg features which are available only
> unified hieararchy and that is what systemd is using already.

I'm not quite sure what the above sentence is trying to say.

> > You gotta
> > change the layout to configure resource control no matter what and
> > it's pretty easy to do. systemd folks are planning to integrate higher
> > level resource control features, so my expectation is that the default
> > layout is gonna change as it develops.
> 
> Do you have any pointers to those discussions? I am not really following
> systemd development.

There's a plan to integrate streamlined implementation of oomd into
systemd. There was a thread somewhere but the only thing I can find
now is a phoronix link.

  https://www.phoronix.com/scan.php?page=news_item&px=Systemd-Facebook-OOMD

systemd recently implemented DisableControllers so that upper level
slices can have authority over what controllers are enabled below it
and in a similar vein there were discussions over making it
auto-propagate some of the configs down the hierarchy but kernel doing
the right thing and maintaining consistent semantics across
controllers seems to be the right approach.

There was also a discussion with a distro. Nothing concrete yet but I
think we're more likely to see more resource control configs being
deployed by default in the future.

> Anyway, I am skeptical that systemd can do anything much more clever
> than placing cgroups with a resource control under the root cgroup. At
> least not without some tagging which workloads are somehow related.

Yeah, exactly, all it needs to do is placing scopes / services
according to resource hierarchy and configure overall policy at higher
level slices, which is exactly what the memory.low semantics change
will allow.

> That being said, I do not really blame systemd here. We are not making
> their life particularly easy TBH.

Do you mind elaborating a bit?

Thanks.

-- 
tejun
