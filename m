From: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Subject: Re: [PATCH] memcg: fix the document of pgpgin/pgpgout
Date: Tue, 22 Nov 2011 10:06:18 +0900
Message-ID: <20111122100618.6d5fbd97.kamezawa.hiroyu@jp.fujitsu.com>
References: <1321922925-14930-1-git-send-email-yinghan@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1321922925-14930-1-git-send-email-yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Ying Han <yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Wanlong Gao <gaowanlong-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Mon, 21 Nov 2011 16:48:45 -0800
Ying Han <yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:

> The two memcg stats pgpgin/pgpgout have different meaning than the ones in
> vmstat, which indicates that we picked a bad naming for them. It might be late
> to change the stat name, but better documentation is always helpful.
> 
> Signed-off-by: Ying Han <yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>

--
To unsubscribe from this list: send the line "unsubscribe cgroups" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
