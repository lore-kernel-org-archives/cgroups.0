From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC v2 0/6] Proposal for a GPU cgroup controller
Date: Mon, 14 Feb 2022 09:23:20 -1000
Message-ID: <YgqsKHS0wbZFrDkO@slm.duckdns.org>
References: <20220211161831.3493782-1-tjmercier@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=faMCUXgtmx+3AXg49JAI78UUXqy95249g9sm+/df9gg=;
        b=U1A+Bb18rPgucS1CdIquKO/KQlC0eR27NKxSUImY8Oiy7D1wNhaId2KoUHB4btYKEU
         4u9Zjg2eEAKHQ5kHwKidGlgPI8du5J16z8F+sJNHr6Uj2ZVwdwXJqvgp42B7LBkHCpLx
         fNsVnT2Gql7nO2NdBASFWTya/UuczDhwp9ARH9586d51DW8lEZyTnCfiXIfX1WYapWOE
         GeJhsm3lrs67uSDfIXrlZ1Pf7MRr5EXBs0AUNlNK+7KuWL5jxyEP+eaDXzmgQ6WOcWcS
         c73Yf/mPhRfRVhubGjsd9Yc1/pEuF8KVnxRvakBP5HkToeXTv1SCmGYbuc43TkrLsQRI
         zsHg==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20220211161831.3493782-1-tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "T.J. Mercier" <tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Maarten Lankhorst <maarten.lankhorst-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Maxime Ripard <mripard-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Zimmermann <tzimmermann-l3A5Bk7waGM@public.gmane.org>, David Airlie <airlied-cv59FeDIM0c@public.gmane.org>, Daniel Vetter <daniel-/w4YWyX8dFk@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Todd Kjos <tkjos-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Martijn Coenen <maco-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Joel Fernandes <joel-QYYGw3jwrUn5owFQY34kdNi2O/JbrIOy@public.gmane.org>, Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Hridya Valsaraju <hridya-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Sumit Semwal <sumit.semwal-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig-5C7GfCeVMHo@public.gmane.org>, Benjamin Gaignard <benjamin.gaignard-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Liam Mark <lmark-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Laur

Hello,

On Fri, Feb 11, 2022 at 04:18:23PM +0000, T.J. Mercier wrote:
> The GPU/DRM cgroup controller came into being when a consensus[1]
> was reached that the resources it tracked were unsuitable to be integrated
> into memcg. Originally, the proposed controller was specific to the DRM
> subsystem and was intended to track GEM buffers and GPU-specific
> resources[2]. In order to help establish a unified memory accounting model
> for all GPU and all related subsystems, Daniel Vetter put forth a
> suggestion to move it out of the DRM subsystem so that it can be used by
> other DMA-BUF exporters as well[3]. This RFC proposes an interface that
> does the same.
> 
> [1]: https://patchwork.kernel.org/project/dri-devel/cover/20190501140438.9506-1-brian.welty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org/#22624705
> [2]: https://lore.kernel.org/amd-gfx/20210126214626.16260-1-brian.welty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org/
> [3]: https://lore.kernel.org/amd-gfx/YCVOl8%2F87bqRSQei-dv86pmgwkMBes7Z6vYuT8azUEOm+Xw19@public.gmane.org/

IIRC, the only consensus was that it needs to be a separate controller and
folks had trouble agreeing on resource types, control mechanism and
interface. Imma keep an eye on how the discussion develops among GPU folks.
Please feel free to ping if there's an area my input may be useful.

Thanks.

-- 
tejun
