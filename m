From: Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH v4 05/28] docs: cgroup-v1: convert docs to ReST and
 rename to *.rst
Date: Fri, 14 Jun 2019 14:14:01 -0600
Message-ID: <20190614141401.48bfb266@lwn.net>
References: <cover.1560361364.git.mchehab+samsung@kernel.org>
        <c1dd623359f44f05863456b8bceba0d8f3e42f38.1560361364.git.mchehab+samsung@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <c1dd623359f44f05863456b8bceba0d8f3e42f38.1560361364.git.mchehab+samsung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: Linux Doc Mailing List <linux-doc@vger.kernel.org>, Mauro Carvalho Chehab <mchehab@infradead.org>, linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>, James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>, linux-block@vger.kernel.org, cgroups@vger.kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org, linux-security-module@vger

On Wed, 12 Jun 2019 14:52:41 -0300
Mauro Carvalho Chehab <mchehab+samsung@kernel.org> wrote:

> Convert the cgroup-v1 files to ReST format, in order to
> allow a later addition to the admin-guide.
> 
> The conversion is actually:
>   - add blank lines and identation in order to identify paragraphs;
>   - fix tables markups;
>   - add some lists markups;
>   - mark literal blocks;
>   - adjust title markups.
> 
> At its new index.rst, let's add a :orphan: while this is not linked to
> the main index.rst file, in order to avoid build warnings.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
> Acked-by: Tejun Heo <tj@kernel.org>

This one, too, has linux-next stuff that keeps it from applying to
docs-next.  Tejun, would you like to carry it on top of your work?

(This means I won't be able to apply #6 either, naturally).

Thanks,

jon
