From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/2] kernfs: add kernfs_ops.free operation to free
 resources tied to the file
Date: Wed, 28 Jun 2023 08:02:06 -1000
Message-ID: <ZJx1nkqbQRVCaKgF@slm.duckdns.org>
References: <CAJuCfpFUrPGVSnZ9+CmMz31GjRNN+tNf6nUmiCgx0Cs5ygD64A@mail.gmail.com>
 <CAJuCfpFe2OdBjZkwHW5UCFUbnQh7hbNeqs7B99PXMXdFNjKb5Q@mail.gmail.com>
 <CAJuCfpG2_trH2DuudX_E0CWfMxyTKfPWqJU14zjVxpTk6kPiWQ@mail.gmail.com>
 <ZJuSzlHfbLj3OjvM@slm.duckdns.org>
 <CAJuCfpGoNbLOLm08LWKPOgn05+FB1GEqeMTUSJUZpRmDYQSjpA@mail.gmail.com>
 <20230628-meisennest-redlich-c09e79fde7f7@brauner>
 <CAJuCfpHqZ=5a_2k==FsdBbwDCF7+s7Ji3aZ37LBqUgyXLMz7gA@mail.gmail.com>
 <20230628-faden-qualvoll-6c33b570f54c@brauner>
 <CAJuCfpF=DjwpWuhugJkVzet2diLkf8eagqxjR8iad39odKdeYQ@mail.gmail.com>
 <20230628-spotten-anzweifeln-e494d16de48a@brauner>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687975329; x=1690567329;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+Xqri33yoDNZGyEBQeXSHUSwznC+68J260AdLVrfRsM=;
        b=fDtJ9NZvaS4L1aMwArhLRV5JeI/wTBBLIHL8vVk9VyPyXkkUcWSaX3EmbLVw26eXeq
         7ANcADHHJscIhra53M6SW2Gn+LDPF4FjnB0xSiAl5aEr4rKF9Yjb0actQmuFWCdCREcv
         sC+DMdd90d1TZuLtxhn/bSBGRuZpDhPL57WycoRQdlBGy3sXOMaDlqwyLDgLDKemtxph
         +AI5R3vAfMJP43uStb2EkBDHSQvwAwsc5fRPN8jh3VMpSCB5TxsPc3O+YqDr3TIy8rQY
         gGltQb8siAYWAQ4n+U9PjL3QTJwytuo5j1gTUPlDv6/wcETdqWWDOviV2y6+SHqKteaW
         YStQ==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20230628-spotten-anzweifeln-e494d16de48a@brauner>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, lujialin4-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ebiggers-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, dietmar.eggemann-5wv7dgnIgG8@public.gmane.org, rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org, bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mgorman-l3A5Bk7waGM@public.gmane.org, bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, vschneid-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org

On Wed, Jun 28, 2023 at 07:35:20PM +0200, Christian Brauner wrote:
> > To summarize my understanding of your proposal, you suggest adding new
> > kernfs_ops for the case you marked (1) and change ->release() to do
> > only (2). Please correct me if I misunderstood. Greg, Tejun, WDYT?
> 
> Yes. I can't claim to know all the intricate implementation details of
> kernfs ofc but this seems sane to me.

This is going to be massively confusing for vast majority of kernfs users.
The contract kernfs provides is that you can tell kernfs that you want out
and then you can do so synchronously in a finite amount of time (you still
have to wait for in-flight operations to finish but that's under your
control). Adding an operation which outlives that contract as something
usual to use is guaranteed to lead to obscure future crnashes. For a
temporary fix, it's fine as long as it's marked clearly but please don't
make it something seemingly widely useable.

We have a long history of modules causing crashes because of this. The
severing semantics is not there just for fun.

Thanks.

-- 
tejun
