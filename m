From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 0/4] Track exported dma-buffers with memcg
Date: Thu, 12 Jan 2023 08:13:37 +0000
Message-ID: <20230112081337.fxgnhdk44mxu26et@google.com>
References: <20230109213809.418135-1-tjmercier@google.com> <CALvZod4ru7F38tAO-gM9ZFKaEhS0w3KqFbPwhwcTvgJs4xMUow@mail.gmail.com>
 <Y78+rfzXPq5XGs9O@phenom.ffwll.local> <CABdmKX0TAv=iRz0s+F6dVVX=xsK00BeUPkRM4bnsfemDAY9U4w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=VWdRXf2+F3B6naWulQRoVncCtgT+T33N/C9h1MKyUek=;
        b=RGhd7Gam36sQbHlynE0qAtHIsyX4aCLddPEY2Ot/Dgnedc14Puqc+N15BF4HB1+p/F
         EyiFI8PkNHaolrVoe7QK5BM3CZp8vk6W4pTXG5t695yYCvf//btA1VGQaXM5Z9EWJrrS
         xLHhPHGK7LgyKGGfWBnGBtXkZ8Wr4/C7eaUCkaE01oIFkojxBDOH6PCPZu8BNx5Djp6V
         IfwRrmeF7rOuyASGIPSCTwqUXba95DqJIXmf+I/r32QKtPTm9Z4todzk318w55UFVqKx
         +j/E0vEN9DOhznh8mKC4jQPd/KfjI32B1A83D6ZGmdcx152TXiUUGw3Pro8wO5zpPEJ8
         n0bQ==
In-Reply-To: <CABdmKX0TAv=iRz0s+F6dVVX=xsK00BeUPkRM4bnsfemDAY9U4w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: "T.J. Mercier" <tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Arve =?utf-8?B?SGrDuG5uZXbDpWc=?= <arve-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Todd Kjos <tkjos-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Martijn Coenen <maco-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Joel Fernandes <joel-QYYGw3jwrUn5owFQY34kdNi2O/JbrIOy@public.gmane.org>, Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Carlos Llamas <cmllamas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Sumit Semwal <sumit.semwal-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Christian =?utf-8?B?S8O2bmln?= <christian.koenig-5C7GfCeVMHo@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Paul Moore <paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org>

On Wed, Jan 11, 2023 at 04:49:36PM -0800, T.J. Mercier wrote:
> 
[...]
> > The problem is a bit that with gpu allocations reclaim is essentially "we
> > pass the error to userspace and they get to sort the mess out". There are
> > some exceptions (some gpu drivers to have shrinkers) would we need to make
> > sure these shrinkers are tied into the cgroup stuff before we could enable
> > charging for them?
> >
> I'm also not sure that we can depend on the dmabuf being backed at
> export time 100% of the time? (They are for dmabuf heaps.) If not,
> that'd make calling the existing memcg folio based functions a bit
> difficult.
> 

Where does the actual memory get allocated? I see the first patch is
updating the stat in dma_buf_export() and dma_buf_release(). Does the
memory get allocated and freed in those code paths?
