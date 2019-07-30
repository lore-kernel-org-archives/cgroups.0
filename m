From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 01/12] rdmacg: Replace strncmp with str_has_prefix
Date: Tue, 30 Jul 2019 11:01:18 -0400
Message-ID: <20190730110118.36853a8b@gandalf.local.home>
References: <20190729151346.9280-1-hslester96@gmail.com>
        <201907292117.DA40CA7D@keescook>
        <CANhBUQ3V2A-TBVizVh+eMLSi5Gzw5sMBY7C-0a8=-z15qyQ75w@mail.gmail.com>
        <80fbaf63ddbe66cbbf3391256402295af1a3336f.camel@perches.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <80fbaf63ddbe66cbbf3391256402295af1a3336f.camel@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Joe Perches <joe@perches.com>
Cc: Chuhong Yuan <hslester96@gmail.com>, Kees Cook <keescook@chromium.org>, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Laura Abbott <labbott@redhat.com>, Michael Ellerman <mpe@ellerman.id.au>

On Tue, 30 Jul 2019 00:03:28 -0700
Joe Perches <joe@perches.com> wrote:

> I believe I'm still in favor of global conversion of
> strstarts to str_has_prefix.
> 

So am I.

-- Steve
