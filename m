From: Joonsoo Kim <js1304-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 17/18] mm: memcontrol: delete unused lrucare handling
Date: Fri, 24 Apr 2020 09:46:13 +0900
Message-ID: <20200424004612.GG13929@js1304-desktop>
References: <20200420221126.341272-1-hannes@cmpxchg.org>
 <20200420221126.341272-18-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=tS4YR94ffeglZIc0ae9Egn1RyfphZpTWVsnteoZ0LM0=;
        b=JNykblARi0mDZ2qQGAafT9vjr7RYTEdye49idwBZWvbw63S4gUAY383YJ3i36TaQN3
         7GPxqLPQL4MgH2Iy1SgjYTAqnVojfdGr1oAXj/t8tm6XJmESgqS2p+jBk17ZAxIfXPAv
         QNtAt0fPaCFL9y8+4M6JMd9uDNA0PdZjiTmz16FtXfJr/M5/mZL76+11CaZ5ldaSYo33
         Yj3Y8OZdVmnoR2nOOTe+hM9TW1Z9V24kIcSXssRlFLXvZ7J4719aW8c4+r2xrtP2JuOV
         dOSc4OV8jOakzzXKq5M7Dpmlisf62SldrNpzAAYk//OrGQuPdsTe/q31tllBjaB3ejt2
         YAFQ==
Content-Disposition: inline
In-Reply-To: <20200420221126.341272-18-hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Mon, Apr 20, 2020 at 06:11:25PM -0400, Johannes Weiner wrote:
> Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

Code looks fine to me. With proper commit message,

Reviewed-by: Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>

Thanks.
