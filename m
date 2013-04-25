From: David Shwatrz <dshwatrz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: cgroup sysfs entry
Date: Thu, 25 Apr 2013 22:39:12 +0300
Message-ID: <CAJJAcod9kNkdEvVf8GyHqqdzzC0Px1EdHwNtv68e-XtMXVo8zw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:x-received:date:message-id:subject:from:to
         :content-type;
        bh=oV/aijNUKEPxpCUX0JhBt+1ZFCu6n5dqskl15lrJXlo=;
        b=FWUV6ULzbw+KCBaXGgqJqGxiAoVgabL5ByCNN0gsUtfxNJbkghjHildwW2ZQ/4qfB+
         Ecp7CTwHIgwVgXYiilaL4fL17YF7NWaCqve2G9fHfted3dGQWf2wJ+va7DdoJszlQiZs
         KZePz+fr5P2fAnO4y5N9qxRHd6IZtfoLToyfU13jDHgGgg4uVxmjvyk+PsgDu3hSMUn2
         ZbK69MN9r3sZmy7dWAOcf68Hawe3B73UPQUD2bK34wgzwDQGQ85y/nd5XgcCfmgrSNwH
         sCII2irbxQewOFpN6YAysgRMbA5FedhMTHZHjY3amsMB/Js8doX8nsiYJWsCL3mrrKCG
         Mj7A==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

I have a question about cgroup implementation:

The /sys/fs/cgroup entry is created in kernel/cgroup.c:

static struct kobject *cgroup_kobj;

cgroup_init(void) {
...
cgroup_kobj = kobject_create_and_add("cgroup", fs_kobj);
  if (!cgroup_kobj) {
  err = -ENOMEM;
  goto out;
  }

}

I wondered about this two points:
1) why is the /sys/fs/cgroup entry created at all?
2) why is this done as a sysfs entry.

The cgroup_kobj is not used anywhere in this module apart from
its creation above (and destroying if we later fail with
register_filesystem() in this same method). I don't see anywhere usage
of syfs API to create files underneath
it. In fact, the entries beneath it are created by mkdir of admin or
systemd code. so what's the point of it being a sysfs entry ? wouldn't
simply mkdir be ok ? and why under /sys/fs?

Since cgroups can be mounted by definition on every path, why this is needed?


Regards,
DavidS
