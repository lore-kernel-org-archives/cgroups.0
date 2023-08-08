From: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH] mm/memcontrol: add tips for kmem.slabinfo
Date: Tue, 8 Aug 2023 03:47:43 +0100
Message-ID: <ZNGsz3FC6q/jJ0+Z@casper.infradead.org>
References: <20230808022229.1560559-1-xiongwei.song@windriver.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=X6zutb3DGwAyU/hRMIK6avnO6sQpvb4ZOPUfHytZ5UA=; b=hyI3vi0lOI+695fAJ+lMtanUIf
        jNbiQH6cQrWfwqs+wO6PSXIYXN/oMIVddImF2MgMZbjVyU9hSfr5vlLwbS7xFhxKpTaT4Lc/KOESb
        X8sWcp9MgoU+6Jq953HGloDlLtKWq3T2ZsT3xC9Rta/5FM4gWXenA/6mA0P0JnYKD6ZYOyS9ZwV8o
        wC3uFZH9lBm0qPTTD/AhLC496IXhHerUkbSywAgkqH4uX4iP0NdlVdvtUvFZMw3SAyf90st4bIbxl
        jMuzEsjec7vb+Cu7oV49dZxMKJCjhi2cwdG2LZM+oZ40zoa1t4zd2qHEHjEXPMuF/a8gs0v5p5gu1
        Guiq6hrA==;
Content-Disposition: inline
In-Reply-To: <20230808022229.1560559-1-xiongwei.song-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: xiongwei.song-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Aug 08, 2023 at 10:22:29AM +0800, xiongwei.song-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org wrote:
> From: Xiongwei Song <xiongwei.song-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org>
> 
> No any output from kmem.slabinfo, which is not friendly. Adding
> tips for it.

What happens to tools which look in this file?
