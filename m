From: Udayan Bapat <uvbapat-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: cgroup monitoring support tool
Date: Wed, 11 Apr 2012 14:10:34 -0400
Message-ID: <CAJ7NSKr6pKned8JqGu=RAJHj_s2_UZp9Cei+WD-jGJaJYZCqBg@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:date:message-id:subject:from:to:content-type;
        bh=5ksPLMRwjTEy6kZP5nsYK3pWEtHnaTpgjs60lIeoYEI=;
        b=rVuS/vifHReP+II+EHmUpK3XivX6sysdPF2oVZ9+7ajdOkbIRmlZlIi1msZ+u3fIw7
         rgoJRt/FEP8lnLnVVHB2Iu0zLYPvMrx4aUhlLNvPAEH4eCMT1rEL5S3CPEjX4IOqYnci
         Riv8CJTVq0oxHdCb6l3bst7mi6eoigvB9VNuMqFfFtl4JHnqjiWRvdl3Ooyzw8w4FguD
         2ETsPkhx5HsE6/9wAdCPNx7OcWKAeaqUywNIz+dqeqs5Q8+StDvlCqMz/OcbkdepS0UV
         t7uyfpp28cJmMJ+yEzv2YdbYdNBe/gFFzYJt25KwBVQdiwh0TPAgMw3XLzLZPW51a4GD
         NaNA==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi all,

We are making some design choices based on the CPU % guarantees
provided by use of cgroups. I was wondering is a kernel patch or user
land tool exists to provide a meaningful representation of existing
CPU slices?

e.g. I have two cgroups in system with 1024 shares, I would expect
both of them running at 50% on an average. So I would like to know if
by running this 'utility' I get the list of cgroups in system with
their execution quantum in the last say 5 mins. I understand this
information can be extracted out from CPU accounting files from each
cgroup, but wanted to check if such patch/tool already exists before I
start writing one.

This will provide good debugging insight if a performance issues are
to be seen later.

Thanks in advance!

Udayan Bapat
