From: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Subject: Re: [PATCH v4 2/2] net: memcg: late association of sock to memcg
Date: Tue, 10 Mar 2020 15:38:48 -0700
Message-ID: <20200310223848.GC96999@carbon.dhcp.thefacebook.com>
References: <20200310051606.33121-1-shakeelb@google.com>
 <20200310051606.33121-2-shakeelb@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=42eT40sFP+9KYDh+3vlLMH6rGIDplm/89EAughFcMVA=;
 b=L82H7GjHGpJCnOI268kTXJLkR3CNE74iPQCm+69ckcxQStB3NUQ4Phajn6ocHyhmnaDf
 Ro2IuLRRiT/kvmyLG9vJubm2LHmj+UcX+Ac3RkhbCMpsvckdJ9Ydv64VZMGkT+8eVllt
 1pdYnPxADX03eCJJmLihfuPnNppMNwsQXak= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=42eT40sFP+9KYDh+3vlLMH6rGIDplm/89EAughFcMVA=;
 b=c72SQQxyvs++c/j1hyQWztpgf0VyEleupBRvc2UjSD2k/hJ04gwl4VomcvlySCZPT8GRZFBO6NGPnYRLjcdhAgVOU1lCCe8qsj8W89+GZEKpwxR9yj0YHlNNwPP46dWzLnUEo2pZJ0X5tFknmMsiG7+Y/VVRJCB15EdRR9UaETc=
Content-Disposition: inline
In-Reply-To: <20200310051606.33121-2-shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "David S . Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Alexey Kuznetsov <kuznet-v/Mj1YrvjDBInbfyfbPRSQ@public.gmane.org>, Hideaki YOSHIFUJI <yoshfuji-VfPWfsRibaP+Ru+s062T9g@public.gmane.org>, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, Mar 09, 2020 at 10:16:06PM -0700, Shakeel Butt wrote:
> If a TCP socket is allocated in IRQ context or cloned from unassociated
> (i.e. not associated to a memcg) in IRQ context then it will remain
> unassociated for its whole life. Almost half of the TCPs created on the
> system are created in IRQ context, so, memory used by such sockets will
> not be accounted by the memcg.
> 
> This issue is more widespread in cgroup v1 where network memory
> accounting is opt-in but it can happen in cgroup v2 if the source socket
> for the cloning was created in root memcg.
> 
> To fix the issue, just do the association of the sockets at the accept()
> time in the process context and then force charge the memory buffer
> already used and reserved by the socket.
> 
> Signed-off-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Reviewed-by: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>

Thank you!
