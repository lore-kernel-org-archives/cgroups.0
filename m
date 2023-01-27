From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v2 0/5] Introduce memcg_stock_pcp remote draining
Date: Fri, 27 Jan 2023 08:20:48 +0100
Message-ID: <Y9N7UMrLTyZT71uA@dhcp22.suse.cz>
References: <20230125073502.743446-1-leobras@redhat.com>
 <Y9DpbVF+JR/G+5Or@dhcp22.suse.cz>
 <9e61ab53e1419a144f774b95230b789244895424.camel@redhat.com>
 <Y9FzSBw10MGXm2TK@tpad>
 <Y9G36AiqPPFDlax3@P9FQF9L96D.corp.robot.car>
 <Y9Iurktut9B9T+Tl@dhcp22.suse.cz>
 <Y9MI42NSLooyVZNu@P9FQF9L96D.corp.robot.car>
 <55ac6e3cbb97c7d13c49c3125c1455d8a2c785c3.camel@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1674804049; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=J1b282C081iblMIexq22+0/YOFRCsX9BkcK/Nyqy0So=;
        b=JMW3EofPMuJ2RfjKSleTooHn6JwOp8Aj+7pQcj73S3EoOVFbIy3N8lOq8a5hiKXj9BaSBV
        oX4l1jcsimsbQfka8Gp3SOjtMk9ndSR+AhMEkipWR4Jbpmjg4vKYsJpexZNCPN2NBievBB
        tbgBkCPmBFSmSp+InsONX5T/WMDxLQE=
Content-Disposition: inline
In-Reply-To: <55ac6e3cbb97c7d13c49c3125c1455d8a2c785c3.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Leonardo =?iso-8859-1?Q?Br=E1s?= <leobras-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Marcelo Tosatti <mtosatti-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri 27-01-23 04:14:19, Leonardo Br=E1s wrote:
> On Thu, 2023-01-26 at 15:12 -0800, Roman Gushchin wrote:
[...]
> > I'd rather opt out of stock draining for isolated cpus: it might slight=
ly reduce
> > the accuracy of memory limits and slightly increase the memory footprin=
t (all
> > those dying memcgs...), but the impact will be limited. Actually it is =
limited
> > by the number of cpus.
>=20
> I was discussing this same idea with Marcelo yesterday morning.
>=20
> The questions had in the topic were:
> a - About how many pages the pcp cache will hold before draining them its=
elf?=A0

MEMCG_CHARGE_BATCH (64 currently). And one more clarification. The cache
doesn't really hold any pages. It is a mere counter of how many charges
have been accounted for the memcg page counter. So it is not really
consuming proportional amount of resources. It just pins the
corresponding memcg. Have a look at consume_stock and refill_stock

> b - Would it cache any kind of bigger page, or huge page in this same asp=
ect?

The above should answer this as well as those following up I hope. If
not let me know.
--=20
Michal Hocko
SUSE Labs
