From: nanzi yang <952508578nanziyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Report Bug to Linux Control Group
Date: Tue, 20 Apr 2021 17:48:28 +0800
Message-ID: <CADRjgdb2NsYikK13GZw3xk+C95q8M3LEqnoCtS-=nPhoy3-mSQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=q4PsK1IB6S8NhB6JTxksI5uH1aB7Bg8w1NjrAu/sUPM=;
        b=dKFnCjwDxYwTvpOtv5Kznjgvr2Pz+BblbsK/1VgtM/ezwULuTHIuWfAvlES7ZY02/q
         1W6oy0s4vdBPooQYOJQlElGbJldAZMnpM5Lf2cYwAahHUgtBecoskmYOQBSrWeHeJu7h
         BqXFlWUIkHFJErSSP+xBy3dsqup8kkVXbCTVwujcCUeqiou7S46aIN0Fa1Cl/oOUnz7o
         MB1l6LgUBe/LtxrBHBge9LWuQlUtj9ZLtP1LZytydZ/uhYuMFlmRA3I8e7U04HgRK7rK
         KaoEWdU9HAhvITz0ArIkBa2kVQUpFUajUr06dfRDJ1BvFQaRfi61J0DWi8NBQOn58ZlA
         amNw==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shenwenbo-Y5EWUtBUdg4nDS1+zs4M5A@public.gmane.org

Hi, our team has found a problem in fs system on Linux kernel v5.10,
leading to DoS attacks.



The struct file can be exhausted by normal users by calling multiple
syscalls such as timerfd_create/pipe/open etc. Although the rlimit
limits the max fds could be opened by a single process. A normal user
can fork multiple processes, repeatedly make the
timerfd_create/pipe/open syscalls and exhaust all struct files. As a
result, all struct-file-allocation related operations of all other
users will fail.



In fact, we try this attack inside a deprivileged docker container
without any capabilities. The processes in the docker can exhaust all
struct-file on the host kernel. We use a machine with 16G memory. We
start 2000 processes, each process with a 1024 limit. In total, around
1613400 number struct-file are consumed and there is no available
struct-file in the kernel. The total consumed memory is less than 2G,
which is small, so the memory control group can not help.



They are caused by the code snippets listed below:

/*----------------fs/file_table.c----------------*/

   ......

134 struct file *alloc_empty_file(int flags, const struct cred *cred)

135 {

        ......

142     if (get_nr_files() >= files_stat.max_files && !capable(CAP_SYS_ADMIN)) {

               ......

147            if (percpu_counter_sum_positive(&nr_files) >=
files_stat.max_files)

148                   goto over;

149     }

       ......

157 over:

       ......

163     return ERR_PTR(-ENFILE);

164 }

/*-----------------------------------------------*/

The code at line 147 could be triggered by syscalls
timerfd_create/pipe/open etc. Besides, there are no  Linux control
groups or Linux namespaces that can limit or isolate the struct file
resources. Is there necessary to create a new control group or
namespace to defend against this attack?



Looking forward to your reply!


                                                       Nanzi Yang
