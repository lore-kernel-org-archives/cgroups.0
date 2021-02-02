From: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Subject: Re: [PATCH 2/7] mm: memcontrol: kill mem_cgroup_nodeinfo()
Date: Tue, 2 Feb 2021 15:13:44 -0800
Message-ID: <20210202231344.GB1812008@carbon.dhcp.thefacebook.com>
References: <20210202184746.119084-1-hannes@cmpxchg.org>
 <20210202184746.119084-3-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=7tzVTPyx4rpKoIzpxIZnjNEZZVV9myz618FwTDHYA1E=;
 b=NgiauNtJg9b9WxytAsO370Zmh68281lDc45e0Lmqh95n7Xf8z5MciroDhMBc+/RkB7o4
 AQu9JMAhDLdq2E1qgQYqPfPUp8DQmEAk82lciqTIUYPJWNtDQ+UWj7kHLZYsUhVoYZvl
 Ac4+ARtzr4wCfGTUuireogzjJ5jr+yyL+lI= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7tzVTPyx4rpKoIzpxIZnjNEZZVV9myz618FwTDHYA1E=;
 b=YPUscs+iHlUvABdiSwUVPZyrAay2czkfvzFI+SKPmG4MoHXFv/nrZl17mdpL8Rmg4OHCon3mGLT8tbappeB9T6Vp545o8jOB99LyjtxjYLFMky3DRc2RkXqZ1iMRTNg0ZTcvkH0krCI3Vp+gpAc6ZjrtHBq6CAG4YLexMB2hThA=
Content-Disposition: inline
In-Reply-To: <20210202184746.119084-3-hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Tue, Feb 02, 2021 at 01:47:41PM -0500, Johannes Weiner wrote:
> No need to encapsulate a simple struct member access.
> 
> Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

Reviewed-by: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
