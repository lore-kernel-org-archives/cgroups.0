From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: memory-cgroup bug
Date: Sun, 25 Nov 2012 14:44:40 +0100
Message-ID: <20121125134440.GD10623@dhcp22.suse.cz>
References: <20121122214249.GA20319@dhcp22.suse.cz>
 <20121122233434.3D5E35E6@pobox.sk>
 <20121123074023.GA24698@dhcp22.suse.cz>
 <20121123102137.10D6D653@pobox.sk>
 <20121123100438.GF24698@dhcp22.suse.cz>
 <20121123155904.490039C5@pobox.sk>
 <20121125101707.GA10623@dhcp22.suse.cz>
 <20121125133953.AD1B2F0A@pobox.sk>
 <20121125130208.GC10623@dhcp22.suse.cz>
 <20121125142709.19F4E8C2@pobox.sk>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=mfRXSlbaRf5QSWtz2E6IfCZGhrpXqwtuzrJhon/y8X4=;
        b=suJpFAosvzWEDCJ7192V1YNXQzxkq96xN886ypAVQ5LeT2IyhevtNoRiJAh+nsc296
         vGK6TTpe3gBQ59WLyu1GRDQPky4TSwf/rZU56++kGvJ55TN3/Z6InTrieqwcvSJBzvpd
         m7eBIIavg1vg4zgJ81Xz7ETvpA8jYd1FM4Cx4vbT1y6VNHk6W1JKkUFWEEHS4avvSUVQ
         EGJdRowdyVvstjjjtuYdPzGi+4wOhletgrBCtImuVUL6ixMItG/3aysv6HlY8rSc84En
         vj/pRy0C+R6frNa2nR+0OUO7QwR+4jUnILEtKJxiihRR2HKGe9GJ69sCUR5A7/5HG9NQ
         CCEQ==
Content-Disposition: inline
In-Reply-To: <20121125142709.19F4E8C2-Rm0zKEqwvD4@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: azurIt <azurit-Rm0zKEqwvD4@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups mailinglist <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Sun 25-11-12 14:27:09, azurIt wrote:
> >> Thank you very much, i will install it ASAP (probably this night).
> >
> >Please don't. If my analysis is correct which I am almost 100% sure it
> >is then it would cause excessive logging. I am sorry I cannot come up
> >with something else in the mean time.
> 
> 
> Ok then. I will, meanwhile, try to contact Andrea Righi (author of
> cgroup-task etc.) and ask him to send here his opinion about relation
> between freezes and his patches.

As I described in other email. This seems to be a deadlock in memcg oom
so I do not think that other patches influence this.

-- 
Michal Hocko
SUSE Labs
