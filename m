From: Yosry Ahmed <yosryahmed@google.com>
Subject: Re: [PATCH v3 2/4] selftests: cgroup: return the errno of write() in
 cg_write() on failure
Date: Fri, 8 Apr 2022 23:43:23 -0700
Message-ID: <CAJD7tkbiLQ8XV89yKDzJ467A7+=xvRMPw3pYwt+0gSnbwqBtVA@mail.gmail.com>
References: <20220408045743.1432968-1-yosryahmed@google.com>
 <20220408045743.1432968-3-yosryahmed@google.com> <CAJD7tkb6VJt=pfqnW11r6S7A0r2Vh85a3YZaVso-qyiCM06nDQ@mail.gmail.com>
 <YlDlCRSyR9xNW5dJ@carbon.dhcp.thefacebook.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4KIbEhpDOtCyioS8BZF5p0mGW/6SLKhNyk9CSQ+cWmo=;
        b=mJomCgJeV+RXmlPTrKz6qrQhrHm7UDKRrcrKS4fB3ekDBuMvYloc6N3zmoewCRpve5
         5wL2KDqW8Z+tm6tNzomwdJaRht0Ve91sWusE4dVKDHUDO7qYsjj+FJxjENUtyF7aeBAn
         dlxb86l3upJFsQhUVQzQHMwAnzbOq3hpu68G8h/vPyJhHFbsDHrlvpzXBgmB8YrMsUU5
         vEnxIy4If3++IMbF512A0INdexqm6swj5Y83/EA90VybgBNxHF6AGuIGFQIKy/ogAVrY
         Fn7I8qbZ/6vMDoiFS2le7qfO1qviRbm+GcB25jK+buDGEz4Q8WoecYXCA5GlPJ+0QAlK
         9Lcg==
In-Reply-To: <YlDlCRSyR9xNW5dJ@carbon.dhcp.thefacebook.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Shakeel Butt <shakeelb@google.com>, Andrew Morton <akpm@linux-foundation.org>, David Rientjes <rientjes@google.com>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>, Yu Zhao <yuzhao@google.com>, Dave Hansen <dave.hansen@linux.intel.com>, Wei Xu <weixugc@google.com>, Greg Thelen <gthelen@google.com>, Chen Wandun <chenwandun@huawei.com>, Vaibhav Jain <vaibhav@linux.ibm.com>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, Tim Chen <tim.c.chen@linux.intel.com>, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>, linux-ksel

On Fri, Apr 8, 2022 at 6:44 PM Roman Gushchin <roman.gushchin@linux.dev> wrote:
>
> On Fri, Apr 08, 2022 at 06:21:55PM -0700, Yosry Ahmed wrote:
> > On Thu, Apr 7, 2022 at 9:57 PM Yosry Ahmed <yosryahmed@google.com> wrote:
> > >
> > > Currently, cg_write() returns 0 on success and -1 on failure. Modify it
> > > to return the errno of write() syscall when write() fails.
> > >
> > > Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
> > > ---
> > >  tools/testing/selftests/cgroup/cgroup_util.c | 32 +++++++++++---------
> > >  1 file changed, 17 insertions(+), 15 deletions(-)
> > >
> > > diff --git a/tools/testing/selftests/cgroup/cgroup_util.c b/tools/testing/selftests/cgroup/cgroup_util.c
> > > index dbaa7aabbb4a..3b6bb09985fa 100644
> > > --- a/tools/testing/selftests/cgroup/cgroup_util.c
> > > +++ b/tools/testing/selftests/cgroup/cgroup_util.c
> > > @@ -38,23 +38,23 @@ static ssize_t read_text(const char *path, char *buf, size_t max_len)
> > >         return len;
> > >  }
> > >
> > > -static ssize_t write_text(const char *path, char *buf, ssize_t len)
> > > +/*
> > > + * Returns:
> > > + *     success -> 0
> > > + *     open() failure -> -1
> > > + *     write() failure -> errno
> > > + */
> > > +static int write_text(const char *path, char *buf, ssize_t len)
> > >  {
> > > -       int fd;
> > > +       int fd, ret;
> > >
> > >         fd = open(path, O_WRONLY | O_APPEND);
> > >         if (fd < 0)
> > >                 return fd;
> > >
> > > -       len = write(fd, buf, len);
> > > -       if (len < 0) {
> > > -               close(fd);
> > > -               return len;
> > > -       }
> > > -
> > > +       ret = write(fd, buf, len) < 0 ? errno : 0;
> > >         close(fd);
> > > -
> > > -       return len;
> > > +       return ret;
> > >  }
> > >
> > >  char *cg_name(const char *root, const char *name)
> > > @@ -177,17 +177,19 @@ long cg_read_lc(const char *cgroup, const char *control)
> > >         return cnt;
> > >  }
> > >
> > > +/*
> > > + * Returns:
> > > + *     success -> 0
> > > + *     open() failure -> -1
> > > + *     write() failure -> errno
> > > + */
> > >  int cg_write(const char *cgroup, const char *control, char *buf)
> > >  {
> > >         char path[PATH_MAX];
> > >         ssize_t len = strlen(buf);
> > >
> > >         snprintf(path, sizeof(path), "%s/%s", cgroup, control);
> > > -
> > > -       if (write_text(path, buf, len) == len)
> > > -               return 0;
> > > -
> > > -       return -1;
> > > +       return write_text(path, buf, len);
> > >  }
> >
> > I have changed this in v4 to a cleaner implementation that either
> > returns 0 on success or -errno on failure. I also made sure to check
> > that the full buffer was being written, and updated cg_read() as well
> > for the interface to be consistent.
> >
> > Will send out once the discussion on patch 1 in v3 reaches a consensus.
>
> Ok, sounds good, please feel free to add my
> Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
> for the whole series. It looks really nice and ready for merging upstream to me.
>
> Thanks!

Thanks a lot for reviewing it! I would appreciate it if you still took
a look at the v4 version of this patch when I send it (probably early
next week) as it's significantly different and includes changes to
cg_read() and read_text() as well.
