From: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Subject: Re: [PATCH 09/19] io_uring: convert to use vm_account
Date: Mon, 6 Feb 2023 08:29:30 -0700
Message-ID: <52d41a7e-1407-e74f-9206-6dd583b7b6b5@kernel.dk>
References: <cover.c238416f0e82377b449846dbb2459ae9d7030c8e.1675669136.git-series.apopple@nvidia.com>
 <44e6ead48bc53789191b22b0e140aeb82459e75f.1675669136.git-series.apopple@nvidia.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lwFXeEE6OM+Eba5UlMJGqS1S5aU4oc1qRdddqki3enQ=;
        b=iV7stC/flzjebT0ar0vLBLMrRS1Zgfa4EWmzBHUBq2mPfhFfiy+qFMOXKaYBXaQQGk
         fnvpe85ijbA+XlWQ94UEI91LIJSirAEiQC26cj+atSqFnE+QYnQMMcNeGrLRqxpvDdHm
         cKXp4vB0mO9XeLLGwQUUZI3wbYEmaAULlVkLC9CsE5KkerWDgA26PhyGRIEL+ziV9klS
         ZTfXcOrK3NZsSTZLNj0UKWysqi5sQITOs//iVA4UDTrnHQxJv4D61/PAqTL+n/SAEbTK
         vTM7/bdyZpB8JbOAtwXYFZJf7rKJzqFufWbhQVhQXWcz2GzCGUsQMnEh2g1LeDK5qqvq
         LSmA==
Content-Language: en-US
In-Reply-To: <44e6ead48bc53789191b22b0e140aeb82459e75f.1675669136.git-series.apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Alistair Popple <apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org, jhubbard-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org, tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mkoutny-IBi9RG/b67k@public.gmane.org, daniel-/w4YWyX8dFk@public.gmane.org, "Daniel P . Berrange" <berrange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Pavel Begunkov <asml.silence-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, io-uring-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 2/6/23 12:47=E2=80=AFAM, Alistair Popple wrote:
> Convert io_uring to use vm_account instead of directly charging pages
> against the user/mm. Rather than charge pages to both user->locked_vm
> and mm->pinned_vm this will only charge pages to user->locked_vm.

Not sure how we're supposed to review this, when you just send us 9/19
and vm_account_release() is supposedly an earlier patch in this series.

Either CC the whole series, or at least the cover letter, core parts,
and the per-subsystem parts.

--=20
Jens Axboe


