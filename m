From: Parav Pandit <pandit.parav@gmail.com>
Subject: Re: [PATCHv14 0/3] rdmacg: IB/core: rdma controller support
Date: Tue, 10 Jan 2017 10:23:16 -0600
Message-ID: <CAG53R5X=nR7dnRuZ+S3mfJ_Zc-hWOmah=yBjR2VKkkoeeHv8Ew@mail.gmail.com>
References: <1484006535-4245-1-git-send-email-pandit.parav@gmail.com> <20170110161505.GF6666@htj.duckdns.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=hFopQHvKUtG0Hz0Ig/BLdPtAVgG2DQoAIPzsH9E0lL8=;
        b=rrIw1U9KUHWkrCHv6hSJ2gOGJoByRstrkIRnOGUxgkll5uPGZ0VUEyarl5bpm7hsBJ
         nk5M9n+zoe/DadIISKuTs1cJO6rpJzzsi0zEo+e7MLRsCW0cAYQ9qJbfRGXSV4lTU4Qx
         r5b2jnabSWksTGy/oFeEr2IchKDE0FKA7Szxfacsjv70S0MrZqH3zUKc6LOPERJIgIK1
         rEDr+x45dO90N0zyrfl8iIs+FsOANxJz/DTOCSuk8WrTuVyUEEvcGo3snRxmb8w8RIyO
         Bwklv1Vlhqa4xXQcXzfghjEjTQfL8iQh96zfgvJbzSHAxECCq+pX394r82SxCJxogQ5n
         gBIg==
In-Reply-To: <20170110161505.GF6666@htj.duckdns.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: cgroups@vger.kernel.org, linux-doc@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-rdma <linux-rdma@vger.kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Doug Ledford <dledford@redhat.com>, Christoph Hellwig <hch@lst.de>, Liran Liss <liranl@mellanox.com>, "Hefty, Sean" <sean.hefty@intel.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Haggai Eran <haggaie@mellanox.com>, Jonathan Corbet <corbet@lwn.net>, james.l.morris@oracle.com, serge@hallyn.com, Or Gerlitz <ogerlitz@mellanox.com>, Matan Barak <matanb@mellanox.com>, Andrew Morton <akpm@linux-foundation.org>, linux-security-module@vger.kernel.org

On Tue, Jan 10, 2017 at 10:15 AM, Tejun Heo <tj@kernel.org> wrote:
> On Tue, Jan 10, 2017 at 12:02:12AM +0000, Parav Pandit wrote:
>> Patchset is compiled and tested against below Tejun's cgroup tree
>> using cgroup v1 and v2 mode.
>> URL: git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git
>> Branch: for-4.11
>
> Applied 1-3 to cgroup/for-4.11-rdmacg.
>
> Thanks.
>
Thanks Tejun.

> --
> tejun
