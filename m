From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] kernel: move from strlcpy with unused retval to strscpy
Date: Fri, 19 Aug 2022 12:23:59 -0400
Message-ID: <20220819122359.050a3432@gandalf.local.home>
References: <20220818210202.8227-1-wsa+renesas@sang-engineering.com>
        <20220818181506.0d838d02@gandalf.local.home>
        <Yv8lb1tUKxYlAcp8@shikoro>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <bpf-owner@vger.kernel.org>
In-Reply-To: <Yv8lb1tUKxYlAcp8@shikoro>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Wolfram Sang <wsa+renesas@sang-engineering.com>
Cc: linux-kernel@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, Martin KaFai Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>, John Fastabend <john.fastabend@gmail.com>, KP Singh <kpsingh@kernel.org>, Stanislav Fomichev <sdf@google.com>, Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>, Mark Rutland <mark.rutland@arm.com>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, Namhyung Kim <namhyung@kernel.org>, Pet

On Fri, 19 Aug 2022 07:53:51 +0200
Wolfram Sang <wsa+renesas@sang-engineering.com> wrote:

> > But in my cases I actually do trust the source string. They are all  
> 
> The ultimate goal is to remove strlcpy entirely. My motivation is to get
> rid of the extra work for maintainers that they need to ensure that the
> author of a patch paid attention to the detail that the source string
> must be trusted.

After reading Linus's rant, I figured as much.

-- Steve
