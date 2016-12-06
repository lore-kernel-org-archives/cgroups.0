From: Tejun Heo <tj@kernel.org>
Subject: Re: [RESEND][PATCH v4] cgroup: Use CAP_SYS_RESOURCE to allow a
 process to migrate other tasks between cgroups
Date: Tue, 6 Dec 2016 11:55:19 -0500
Message-ID: <20161206165519.GA17648@mtj.duckdns.org>
References: <1478647728-30357-1-git-send-email-john.stultz@linaro.org>
 <CALCETrU5fCWoe0RXfKWuN7Zt9vLvoyHFcZnVqeqiKBpSKrMrxA@mail.gmail.com>
 <20161109000342.GA42532@ast-mbp.thefacebook.com>
 <CALCETrW_mPHneTvcAM6HyBLCJqcwKmcYEoC+kseyuyQZzj2a=A@mail.gmail.com>
 <CALAqxLXk+A9=A0oXGEduphXOQdbMg-wuGxmLkEk9cPHyn44X5Q@mail.gmail.com>
 <CALAqxLW-mq4Lnudtn5KMBPdzBTg5bhTXV9QmUC2vfabVru+fUA@mail.gmail.com>
 <CALCETrWuKpmXQqoQmcy4Va8abdpfCnMBYHWSD0nK5pocj2nfXA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=s9n3ijgTVm8DVQno1L8+dBEuvuSz520y8C+BabvkYRQ=;
        b=epuhjaT4Qhd3kV6Bvb1Y2T7obeEnD0bLZ5DVgq67oiMhDUR747PQ084p4270OH7Jlq
         ho1ccoOmpc7F3+fDvMY/0BwoAhxtfeb0LnZ2qczFVS9bfnUvazXnCEers1+sV9j+7gkD
         NQPD4YDlk5Md5xIeON+zSL99AytrZQNY/9v5FWBI0PqGhHQ0rEATsqWleKiTtHk3XrpZ
         0MR+Tll8m0mp+dbhDABgx69IfsPK/ajmCxU/zjBMYyywSk4hsKkEBuma85YAW1p53KAW
         /z62FLxe2tudPeojPF4CQY3l64dkALLNykEAPrYwh/JdDH7CCO4bk4jU0wG1fSYGC73b
         UIng==
Content-Disposition: inline
In-Reply-To: <CALCETrWuKpmXQqoQmcy4Va8abdpfCnMBYHWSD0nK5pocj2nfXA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andy Lutomirski <luto@amacapital.net>
Cc: John Stultz <john.stultz@linaro.org>, Alexei Starovoitov <alexei.starovoitov@gmail.com>, Andy Lutomirski <luto@kernel.org>, =?iso-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>, Daniel Mack <daniel@zonque.org>, "David S. Miller" <davem@davemloft.net>, kafai@fb.com, Florian Westphal <fw@strlen.de>, Harald Hoyer <harald@redhat.com>, Network Development <netdev@vger.kernel.org>, Sargun Dhillon <sargun@sargun.me>, Pablo Neira Ayuso <pablo@netfilter.org>, lkml <linux-kernel@vger.kernel.org>, Li Zefan <lizefan@huawei.com>, Jonathan Corbet <corbet@lwn.net>, "open list:CONTROL GROUP (CGROUP)" <cgroups@vger.kernel.org>, Android Kernel Team <kernel-team@android.com>, Rom Lemarchand <romlem@android.com>, Colin Cross <ccross@android.com>, Dmitry

Hello,

On Mon, Dec 05, 2016 at 04:36:51PM -0800, Andy Lutomirski wrote:
> I really don't know.  The cgroupfs interface is a bit unfortunate in
> that it doesn't really express the constraints.  To safely migrate a
> task, ISTM you ought to have some form of privilege over the task
> *and* some form of privilege over the cgroup.  cgroupfs only handles
> the latter.
> 
> CAP_CGROUP_MIGRATE ought to be okay.  Or maybe cgroupfs needs to gain
> a concept of "dangerous" cgroups and further restrict them and
> CAP_SYS_RESOURCE should be fine for non-dangerous cgroups?  I think I
> favor the latter, but it might be nice to hear from Tejun first.

If we can't do CAP_SYS_RESOURCE due to overlaps, let's go with a
separate CAP.  While for android and cgroup v1, it's nice to have a
finer grained CAP for security control, privilege isolation in cgroup
should also primarily done through hierarchical delegation.  It
doesn't make sense to have another system in parallel.

We can't do it properly on v1 because some controllers aren't properly
hierarchical and delegation model isn't well defined.  e.g. nothing
prevents a process from being pulled across different subtrees with
the same delegation, but v2 can do it properly.  All that's necessary
is to make the CAP test OR'd to other perm checks instead of AND'ing
so that the CAP just allows overriding restrictions expressed through
delegation but it's normally possible to move processes around in
one's own delegated subtree.

Thanks.

-- 
tejun
