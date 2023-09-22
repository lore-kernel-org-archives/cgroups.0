From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH 0/2] mm: memcg: fix tracking of pending stats updates
 values
Date: Fri, 22 Sep 2023 10:03:10 -0700
Message-ID: <20230922100310.102aa12ac2bdf0568e6e7432@linux-foundation.org>
References: <20230922082542.466579-1-yosryahmed@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1695402192;
        bh=qa/QJ12DIUWvIeySIX2g6kqd2yUHHXJ+BRw50a4IKNU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=uZWF7kJrm5w73mco/RN5kh0tFZqol/wzUHts2vidpRz38ZzJryh0F8Jo8FNJ1KjRS
         fvytGPaP6DT92lWdNVq/FOf7os8h8kRVgIb6Q+blcoSlcD8L3qWYBYT5RU0unpOhYv
         ZQz8Myb6yh3K4y1JaIiCCoPWXMFcaasTV8Kdbmps=
In-Reply-To: <20230922082542.466579-1-yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, =?ISO-8859-1?Q? Michal_Koutn=FD ?= <mkoutny-IBi9RG/b67k@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, 22 Sep 2023 08:25:40 +0000 Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:

> While working on adjacent code [1], I realized that the values passed
> into memcg_rstat_updated() to keep track of the magnitude of pending
> updates is consistent. It is mostly in pages, but sometimes it can be in
> bytes or KBs. Fix that.

Clashes with "memcg: remove unused do_memsw_account in
memcg1_stat_format", and maybe other things.  Can you please redo
against mm-unsstable or linux-next?
