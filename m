From: Dan Schatzberg <schatzberg.dan@gmail.com>
Subject: Re: [PATCH v5 0/4] Charge loop device i/o to issuing cgroup
Date: Tue, 26 May 2020 10:28:03 -0400
Message-ID: <20200526142803.GA1061@dschatzberg-fedora-PC0Y6AEN.dhcp.thefacebook.com>
References: <20200428161355.6377-1-schatzberg.dan@gmail.com>
 <20200512132521.GA28700@dschatzberg-fedora-PC0Y6AEN.dhcp.thefacebook.com>
 <20200512133545.GA26535@infradead.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=0TJ6yYccZvVBdf4f/G2i6OowH5C25Z8m9Ap0zEnVgR8=;
        b=TLMKcn3xE73A18nE6utedMS8Vz8HXK+b0q/Divfxr42WLvfCj1VnejFo7V5BPdLF0q
         W+VJW80hsx5pkyn2afaGJzSd1NY9lzi/WflZh7Okd/ujLflmIzup/UUhAjVe3hjLW/ov
         /ckbc/JaidWP13F1n6QRu3E3MBXNO+SL6qBL9nAMf03UnJq5zUo+MGasn74WqYB3nHlM
         RMvAQzvfJ3xtHcnQf7mOLh7b54gRFUEIEGn2cQ5cWzw7drZMeoCaq8lvxlN5DiCjmw1j
         OWij/qP1w+bHGLFTVBEmayKa6pI5nJLWTt6wzU97k3DMGp051NXEEKMYkQDFm1nLdmm9
         mfkA==
Content-Disposition: inline
In-Reply-To: <20200512133545.GA26535@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>, Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, Amir Goldstein <amir73il@gmail.com>, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>, Roman Gushchin <guro@fb.com>, Shakeel Butt <shakeelb@google.com>, Chris Down <chris@chrisdown.name>, Yang Shi <yang.shi@linux.alibaba.com>, Ingo Molnar <mingo@kernel.org>, "Peter Zijlstra (Intel)" <peterz@infradead.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Andrea Arcangeli <aarcange@redhat.com>, Thomas

On Tue, May 12, 2020 at 06:35:45AM -0700, Christoph Hellwig wrote:
> On Tue, May 12, 2020 at 09:25:21AM -0400, Dan Schatzberg wrote:
> > Seems like discussion on this patch series has died down. There's been
> > a concern raised that we could generalize infrastructure across loop,
> > md, etc. This may be possible, in the future, but it isn't clear to me
> > how this would look like. I'm inclined to fix the existing issue with
> > loop devices now (this is a problem we hit at FB) and address
> > consolidation with other cases if and when those are addressed.
> > 
> > Jens, you've expressed interest in seeing this series go through the
> > block tree so I'm interested in your perspective here. Barring any
> > concrete implementation bugs, would you be okay merging this version?
> 
> Independ of any higher level issues you need to sort out the spinlock
> mess I pointed out.

Will do - I'll split out the lock-use refactor into a separate
patch. Do you have particular concerns about re-using the existing
spinlock? Its existing use is not contended so I didn't see any harm
in extending its use. I'll add this justification to the commit
message as well, but I'm tempted to leave the re-use as is instead of
creating a new lock.
