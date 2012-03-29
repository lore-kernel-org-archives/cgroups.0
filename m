From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: cgroups commit 61d1d219c4 breaks systemd
Date: Thu, 29 Mar 2012 09:04:33 -0700
Message-ID: <20120329160433.GC28941@google.com>
References: <alpine.LNX.2.00.1203282354440.25526@pobox.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=eUA2MSl+2e2q0zDhiPEWugd6oVz8CrAqgluSl1Re1Ho=;
        b=CEe1mTnDAvR2bk4bv2vegr4RwwKflJz2x3irlmqCXE3YSMje0xEUF+oy+kUV8JWXgX
         MErk4TPlUp9eYsn0nOAJ0VG7DtTCFo3RNsndD7GVatMfY/aExKiveDu3b5pt4MwZLIIH
         VcedoLjmrcU+/3RZem+CwGFxCS78JNtYDnLdRdx84agFdoAvcfT1O8rsTqz/v/AEc+qN
         WpFhkhMe/6W0FvRrfxvjRVn4f/hnj7+N1rmCe7/d2Mz46ljvRvOuom54I8+Ffao2JNez
         04YtaNFCCnBZxh2wbRU3JPUsVnK6K6S21SPEfErsDxlBJo4F6Z1ghqM/4LtKJ7P/L2Lt
         cgUg==
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1203282354440.25526-ztGlSCb7Y1iN3ZZ/Hiejyg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>
Cc: Mandeep Singh Baines <msb-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Paul Menage <paul-inf54ven1CmVyaH7bEyXVA@public.gmane.org>, Kay Sievers <kay.sievers-tD+1rO4QERM@public.gmane.org>

(using Li's new address and quoting whole message for him)

The change has been in linux-next for quite some time and I've been
booting fedora 16 a lot of times on top of this.  Weird.  I'll try to
find out what's wrong and if I can't spot it quick enough, will send a
revert patch to Linus.  We can try again later.  Mandeep, any ideas?

Thanks.

On Thu, Mar 29, 2012 at 12:01:26AM +0200, Jiri Kosina wrote:
> Hi,
> 
> I am not able to boot current Linus' tree on system which is using 
> systemd. In the early boot phase I get
> 
> 	Failed to create root cgroup hierarchy: No such process
> 	Failed to allocate manager object: No such process
> 
> and that's it, the system is completely unusable afterwards (not having 
> any console spawned, no networking, etc).
> 
> Bisection pointed to
> 
> 	commit 61d1d219c4c0761059236a46867bc49943c4d29d
> 	Author: Mandeep Singh Baines <msb-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
> 	Date:   Mon Jan 30 12:51:56 2012 -0800
> 
> 	    cgroup: remove extra calls to find_existing_css_set
> 
> and I have verified that reverting this single commit on top of current 
> Linus' tree makes the problem go away and the system boots properly.
> 
> strace output shows that with 61d1d219c applied, systemd is failing while 
> trying to add itself to the systemd cgroup:
> 
> mkdir("/sys", 0755)                     = -1 EEXIST (File exists)
> mkdir("/sys/fs", 0755)                  = -1 EEXIST (File exists)
> mkdir("/sys/fs/cgroup", 0755)           = -1 EEXIST (File exists)
> mkdir("/sys/fs/cgroup/systemd", 0755)   = -1 EEXIST (File exists)
> mkdir("/sys/fs/cgroup/systemd/system", 0755) = 0
> open("/sys/fs/cgroup/systemd/system/tasks", O_WRONLY|O_CREAT|O_TRUNC|O_CLOEXEC, 0666) = 6
> fstat(6, {st_mode=S_IFREG|0644, st_size=0, ...}) = 0
> mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f60c4ecb000
> write(6, "357\n", 4)                    = -1 ESRCH (No such process)
> close(6)                                = 0
> munmap(0x7f60c4ecb000, 4096)            = 0
> writev(3, [{"<27>", 4}, {"systemd", 7}, {"[357]: ", 7}, {"Failed to create root cgroup hierarchy: No such process", 55}, {"\n", 1}], 5) = 74
> open("/sys/fs/cgroup/systemd/system/tasks", O_RDONLY|O_CLOEXEC) = 6
> fstat(6, {st_mode=S_IFREG|0644, st_size=0, ...}) = 0
> mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f60c4ecb000
> read(6, "357\n", 4096)                  = 4
> open("/sys/fs/cgroup/systemd/tasks", O_WRONLY|O_CREAT|O_TRUNC|O_CLOEXEC, 0666) = 7
> fstat(7, {st_mode=S_IFREG|0644, st_size=0, ...}) = 0
> mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f60c4eca000
> write(7, "357\n", 4)                    = -1 ESRCH (No such process)
> close(7)                                = 0
> munmap(0x7f60c4eca000, 4096)            = 0
> read(6, "", 4096)                       = 0
> close(6)                                = 0
> munmap(0x7f60c4ecb000, 4096)            = 0
> open("/sys/fs/cgroup/systemd/system/tasks", O_RDONLY|O_CLOEXEC) = 6
> fstat(6, {st_mode=S_IFREG|0644, st_size=0, ...}) = 0
> mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f60c4ecb000
> read(6, "", 4096)                       = 0
> close(6)                                = 0
> munmap(0x7f60c4ecb000, 4096)            = 0
> open("/sys/fs/cgroup/systemd/system", O_RDONLY|O_NONBLOCK|O_DIRECTORY|O_CLOEXEC) = 6
> getdents(6, /* 7 entries */, 32768)     = 240
> getdents(6, /* 0 entries */, 32768)     = 0
> lstat("/sys/fs/cgroup/systemd/system/tasks", {st_mode=S_IFREG|0644, st_size=0, ...}) = 0
> rmdir("/sys/fs/cgroup/systemd/system")  = 0
> close(6)                                = 0
> close(4)                                = 0
> close(5)                                = 0
> close(0)                                = 0
> writev(3, [{"<27>", 4}, {"systemd", 7}, {"[357]: ", 7}, {"Failed to allocate manager object: No such process", 50}, {"\n", 1}], 5) = 69

-- 
tejun
