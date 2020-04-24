From: Joonsoo Kim <js1304-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 13/18] mm: memcontrol: drop unused try/commit/cancel
 charge API
Date: Fri, 24 Apr 2020 09:30:12 +0900
Message-ID: <20200424003011.GC13929@js1304-desktop>
References: <20200420221126.341272-1-hannes@cmpxchg.org>
 <20200420221126.341272-14-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=BDMXkjuJWWuNQzKMsS1orlq7kdCJZm3J8FZDWv+qlIo=;
        b=o8xbquq9KICTnRce+ky9YCyMckMeUWhi8Xgq0sdLPa9JJ3xD0B99Ss0XfHcSns/6vt
         SyaTrgG44YUlVKA6RkxQVXGp2Ne7pCoT0cpGFWClnwgk2sl9eHQIev2FeUZ6+jtPPGo3
         JAhCT+gVfYx8C5ggBnwi+71vv1iXRSsfeq0Sp1dMYm8X+iLv11nZTQSKa0mc9Nl93ni2
         S4C9loWLUqJnfdrFCEco9+ySBD671KSQB82g8xwDHDr5lpeawq+MTG6uA5Jl2JfDHpQr
         C0jUHCe9vhbv26mDKTtr9uPP2NyjiS9631OTwyVZIR//C0O7vYWO0YDxxBx5LTipmP5S
         /t9g==
Content-Disposition: inline
In-Reply-To: <20200420221126.341272-14-hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Mon, Apr 20, 2020 at 06:11:21PM -0400, Johannes Weiner wrote:
> There are no more users. RIP in peace.
> 
> Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

Reviewed-by: Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>

