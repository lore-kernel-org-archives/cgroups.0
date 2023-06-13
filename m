From: "tj@kernel.org" <tj@kernel.org>
Subject: Re: [PATCH v3 0/2] memcontrol: support cgroup level OOM protection
Date: Mon, 12 Jun 2023 22:40:32 -1000
Message-ID: <ZIgrgGQQ-tYEQJFr@slm.duckdns.org>
References: <ZFd5bpfYc3nPEVie@dhcp22.suse.cz>
 <66F9BB37-3BE1-4B0F-8DE1-97085AF4BED2@didiglobal.com>
 <ZFkEqhAs7FELUO3a@dhcp22.suse.cz>
 <CAJD7tkaw_7vYACsyzAtY9L0ZVC0B=XJEWgG=Ad_dOtL_pBDDvQ@mail.gmail.com>
 <ZIgodGWoC/R07eak@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686645629; x=1689237629;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Uuddb9c9VUE9xG/wODQy6qGOGm/KkteE8GYq9MCwRAo=;
        b=hHVs3qPi0Aq8cI3ZELcon2W8/5mlGpERDvjit7DNkZJGLihmbAwJbkACfzIIgkxIpc
         j4vFdsP/WWW0wIJd/+64pTHuEO5ZVFDRuI3Ji6gM8fK45NJlH0e7e/arPF6r2r2akpsM
         +P2AQH9buFVjbPQZ+tH8SrQvxbwlEmqMjiKsi3b2c61QcoDyZqrxyk3f27/fjkKTuQeH
         oJykroMIDIs7GXAhup68spefTPKSnD3abb/0MnqQMjKiiJpTM6AyYrvCdFBlKCBeyInX
         hAmGy+znv8erLXrRjh7AGDf7f3c0YH8bWp8o24v/AElZnau34Ib2Vq14+f23at78jucW
         sshQ==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <ZIgodGWoC/R07eak@dhcp22.suse.cz>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@suse.com>
Cc: Yosry Ahmed <yosryahmed@google.com>, =?utf-8?B?56iL5Z6y5rab?= Chengkaitao Cheng <chengkaitao@didiglobal.com>, "lizefan.x@bytedance.com" <lizefan.x@bytedance.com>, "hannes@cmpxchg.org" <hannes@cmpxchg.org>, "corbet@lwn.net" <corbet@lwn.net>, "roman.gushchin@linux.dev" <roman.gushchin@linux.dev>, "shakeelb@google.com" <shakeelb@google.com>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "brauner@kernel.org" <brauner@kernel.org>, "muchun.song@linux.dev" <muchun.song@linux.dev>, "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, "zhengqi.arch@bytedance.com" <zhengqi.arch@bytedance.com>, "ebiederm@xmission.com" <ebiederm@xmission.com>, "Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>, "chengzhihao1@huawei.com" <chengzhihao1@huawei.com>, pilgrimta

Hello,

On Tue, Jun 13, 2023 at 10:27:32AM +0200, Michal Hocko wrote:
> On the other hand I can see a need to customizable OOM victim selection
> functionality. We've been through that discussion on several other
> occasions and the best thing we could come up with was to allow to plug
> BPF into the victim selection process and allow to bypass the system
> default method. No code has ever materialized from those discussions
> though. Maybe this is the time to revive that idea again?

Yeah, my 5 cent - trying to define a rigid interface for something complex
and flexible is a fool's errand.

Johannes knows a lot better than me but we (meta) are handling most OOMs
with oomd which gives more than sufficient policy flexibility. That said,
handling OOMs in userspace requires wholesale configuration changes (e.g.
working IO isolation) and being able to steer kernel OOM kills can be useful
for many folks. I haven't thought too much about it but the problem seems
pretty well fit for offloading policy decisions to a BPF program.

Thanks.

-- 
tejun
