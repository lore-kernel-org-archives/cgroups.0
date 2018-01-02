From: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: cgroups(7): documenting cgroups v2 thread mode
Date: Tue, 2 Jan 2018 19:24:01 +0100
Message-ID: <b2d54ae2-62db-7402-ed99-7a0e72f90ff4@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=cc:to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=vDnJv7k1XOL5wzAtJwZ4hbCGj0Lw/DjExWWTrP79IJ8=;
        b=sLIOS1QZXU2Tlpy0pkk5DNVyWbx3V7OVA1EFiIcJ5m0SfZ/E9VwOJaDCq4s5LE/965
         YX2otXR0aiZZZD2i+Ts20UJ/Ahg+eKQmfHD4qBhI4qM+cJol4kUcS+oW6C+rMN+yAcwA
         n3C2hCnSc0r+H3osrp2REA+9X7ANoYgrFyIV5M6pK5xPq8Fy+Wxna0vSdHuRBdY9nfiB
         z3Hq0tfXLg4D7LTbCI0lLICKmkHvj9FNi04ezH/luU5Hvd0rSp37UhVJo1P6LQTk4V00
         J23B4F4emEgoaByGqd8E2s3L/U3w2ULOgTOSrD6WBd6XE5NV8driqaN8Pdu5i58ZYA0f
         M32Q==
Content-Language: en-US
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-man <linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, Mike Galbraith <efault-Mmb7MZpHnFY@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, kernel-team-b10kYP2dOMg@public.gmane.org, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Lauro Venancio <lvenanci-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Hello Tejun and all,

To date, the cgroups(7) manual page does not document thread mode
(added in Linux 4.14). Furthermore, the documentation in 
Documentation/cgroup-v2.txt is, I think, a little thin.

I have attempted to address this by adding some extensive documentation
to the cgroups(7) manual page. This text is based on some reading
of Documentation/cgroup-v2.txt, reading of the kernel source, and
quite a lot of experimentation.

The plain-text version for (easy review) is shown below. I would be 
happy to receive review comments/corrections/improvements on the text below. 

In particular, Tejun and Peter, I would be very happy if you could 
take some time to look at this text.

The branch containing the pending cgroups(7) changes can be found at:
https://git.kernel.org/pub/scm/docs/man-pages/man-pages.git/log/?h=draft_cgroup_updates

[[
   CGROUPS V2 THREAD MODE
       Among the restrictions imposed by  cgroups  v2  that  were  not
       present in cgroups v1 are the following:

       *  No  thread-granularity  control:  all  of  the  threads of a
          process must be in the same cgroup.

       *  No internal processes: a cgroup can't both have member  pro‐
          cesses and exercise controllers on child cgroups.

       Both of these restrictions were added because the lack of these
       restrictions had caused problems in cgroups v1.  In particular,
       the  cgroups  v1  ability to allow thread-level granularity for
       cgroup membership made  no  sense  for  some  controllers.   (A
       notable  example was the memory controller: since threads share
       an address space, it made no sense to split threads across dif‐
       ferent memory cgroups.)

       Notwithstanding  the  initial  design  decision  in cgroups v2,
       there were use cases for certain controllers, notably  the  cpu
       controller,  for  which thread-level granularity of control was
       meaningful and useful.  To accommodate such  use  cases,  Linux
       4.14 added thread mode for cgroups v2.

       Thread mode allows the following:

       *  The  creation of threaded subtrees in which the threads of a
          process may be spread across cgroups inside  the  tree.   (A
          threaded  subtree  may  contain  multiple multithreaded pro‐
          cesses.)

       *  The concept of threaded controllers,  which  can  distribute
          resources across the cgroups in a threaded subtree.

       *  A  relaxation  of the "no internal processes rule", so that,
          within a threaded subtree, a cgroup can both contain  member
          threads and exercise resource control over child cgroups.

       With  the addition of thread mode, each nonroot cgroup now con‐
       tains a new file, cgroup.type, that exposes, and in  some  cir‐
       cumstances can be used to change, the "type" of a cgroup.  This
       file contains one of the following type values:

       domain This is a normal v2 cgroup that provides  process-granu‐
              larity  control.   If  a  process  is  a  member of this
              cgroup, then all threads of the process are (by  defini‐
              tion)  in  the  same cgroup.  This is the default cgroup
              type, and provides the same behavior that  was  provided
              for cgroups in the initial cgroups v2 implementation.

       threaded
              This  cgroup is a member of a threaded subtree.  Threads
              can be added to this  cgroup,  and  controllers  can  be
              enabled for the cgroup.

       domain threaded
              This  is  a  domain  cgroup that serves as the root of a
              threaded subtree.  This cgroup type  is  also  known  as
              "threaded root".

       domain invalid
              This is a cgroup inside a threaded subtree that is in an
              "invalid"  state.   Processes  can't  be  added  to  the
              cgroup, and controllers can't be enabled for the cgroup.
              The only thing that can be done with this cgroup  (other
              than  deleting it) is to convert it to a threaded cgroup
              by writing the  string  "threaded"  to  the  cgroup.type
              file.

   Threaded versus domain controllers
       With the addition of threads mode, cgroups v2 now distinguishes
       two types of resource controllers:

       *  Threaded controllers: these controllers support thread-gran‐
          ularity  for  resource  control  and  can  be enabled inside
          threaded subtrees, with the result  that  the  corresponding
          controller-interface  files appear inside the cgroups in the
          threaded subtree.  As at  Linux  4.15,  the  following  con‐
          trollers are threaded: cpu, perf_event, and pids.

       *  Domain  controllers:  these controllers support only process
          granularity for resource control.  From the perspective of a
          domain  controller,  all  threads of a process are always in
          the same cgroup.  Domain controllers can't be enabled inside
          a threaded subtree.

   Creating a threaded subtree
       There  are two pathways that lead to the creation of a threaded
       subtree.  The first pathway proceeds as follows:

       1. We write the string "threaded" to the cgroup.type file of  a
          cgroup y/z that currently has the type domain.  This has the
          following effects:

          *  The type of the cgroup y/z becomes threaded.

          *  The  type  of  the  parent  cgroup,  y,  becomes   domain
             threaded.   The  parent  cgroup is the root of a threaded
             subtree (also known as the "threaded root").

          *  All other cgroups under y that were not already  of  type
             threaded  (because  they  were  inside  already  existing
             threaded subtrees under the new threaded root)  are  con‐
             verted  to type domain invalid.  Any subsequently created
             cgroups under y will also have the type domain invalid.

       2. We write the string "threaded" to each of the domain invalid
          cgroups  under  y,  in  order  to  convert  them to the type
          threaded.  As a consequence of this step, all threads  under
          the  threaded  root  now  have  the  type  threaded  and the
          threaded subtree is now fully usable.   The  requirement  to
          write  "threaded"  to each of these cgroups is somewhat cum‐
          bersome, but allows for possible future  extensions  to  the
          thread-mode model.

          ┌─────────────────────────────────────────────────────┐
          │FIXME                                                │
          ├─────────────────────────────────────────────────────┤
          │Re  the preceding paragraphs... Are there other rea‐ │
          │sosn  for  the  (cumbersome)  requirement  to  write │
          │'threaded'  to  each of the cgroup.type files in the │
          │threaded subtrees? Tejun Heo mentioned  the  follow‐ │
          │ing:                                                 │
          │                                                     │
          │    Consistency w/ the cgroups right under the root  │
          │    cgroup.  Because they can be both domains and    │
          │    threadroots, we can't switch the children over   │
          │    to thread mode automatically.  Doing that for    │
          │    cgroups further down in the hierarchy would be   │
          │    really inconsistent.                             │
          │                                                     │
          │But,  it's  not  clear  to  me  how  "Doing that for │
          │cgroups further  down  in  the  hierarchy  would  be │
          │really inconsistent", since in the current implemen‐ │
          │tation, those same thread groups  are  converted  to │
          │"domain invalid" type.  What am I missing?           │
          └─────────────────────────────────────────────────────┘

       The second way of creating a threaded subtree is as follows:

       1. In  an  existing  cgroup,  z,  that  currently  has the type
          domain, we (1) enable one or more threaded  controllers  and
          (2)  make  a process a member of z.  (These two steps can be
          done in either order.)  This has the following consequences:

          *  The type of z becomes domain threaded.

          *  All of the descendant cgroups of  x  that  are  were  not
             already  of  type  threaded  are converted to type domain
             invalid.

       2. As before, we make the threaded subtree  usable  by  writing
          the  string "threaded" to each of the domain invalid cgroups
          under y, in order to convert them to the type threaded.

       One of the consequences of the above  pathways  to  creating  a
       threaded subtree is that the threaded root cgroup can be a par‐
       ent  only  to  threaded  (and  domain  invalid)  cgroups.   The
       threaded root cgroup can't be a parent of a domain cgroups, and
       a threaded cgroup can't have a sibling that is a domain cgroup.

   Using a threaded subtree
       Within a threaded subtree, threaded controllers can be  enabled
       in  each subgroup whose type has been changed to threaded; upon
       doing so, the corresponding controller interface  files  appear
       in the children of that cgroup.

       A  process  can be moved into a threaded subtree by writing its
       PID to the cgroup.procs file in one of the cgroups  inside  the
       tree.   This has the effect of making all of the threads in the
       process members of  the  corresponding  cgroup  and  makes  the
       process  a  member of the threaded subtree.  The threads of the
       process can then be spread across the threaded subtree by writ‐
       ing  their  thread  IDs  (see  gettid(2)) to the cgroup.threads
       files in different cgroups inside the subtree.  The threads  of
       a process must all reside in the same threaded subtree.

       The  cgroup.threads  file  is present in each cgroup (including
       domain cgroups) and can be read in order to discover the set of
       threads  that  is present in the cgroup.  The set of thread IDs
       obtained when reading this file is not guaranteed to be ordered
       or free of duplicates.

       The  cgroup.procs  file  in the threaded root shows the PIDs of
       all processes that are members of the  threaded  subtree.   The
       cgroup.procs  files in the other cgroups in the subtree are not
       readable.

       Domain controllers can't be enabled in a threaded  subtree;  no
       controller-interface files appear inside the cgroups underneath
       the threaded root.  From the point of view  of  a  domain  con‐
       troller,  threaded  subtrees  are  invisible:  a  multithreaded
       process inside a threaded subtree  appears  to  a  domain  con‐
       troller as a process that resides in the threaded root cgroup.

       Within  a  threaded  subtree,  the "no internal processes" rule
       does not apply: a cgroup can both contain member processes  (or
       thread) and exercise controllers on child cgroups.

   Rules for writing to cgroup.type and creating threaded subtrees
       A number of rules apply when writing to the cgroup.type file:

       *  Only  the string "threaded" may be written.  In other words,
          the only explicit transition that is possible is to  convert
          a domain cgroup to type threaded.

       *  The  string  "threaded"  can  be written only if the current
          value in cgroup.type is one of the following

          ·  domain, to start the creation of a threaded  subtree  via
             the first of the pathways described above;

          ·  domain invalid,  to  convert  one  of  the  cgroups  in a
             threaded subtree into a usable (i.e., threaded) state;

          ·  threaded, which has no effect (a "no-op").

       *  We can't write to a cgroup.type file if the parent's type is
          domain  invalid.   In other words, the cgroups of a threaded
          subtree must be converted to the threaded state  in  a  top-
          down manner.

       There  are  also  various constraints that must be satisfied in
       order to create a threaded subtree rooted at the cgroup x:

       *  There can be no member processes in the  descendant  cgroups
          of x.  (The cgroup x can itself have member processes.)

       *  No  domain  controllers  may  be  enabled in x's cgroup.sub‐
          tree_control file.

       *  The existing cgroups inside the threaded subtree must either
          be  of  type  domain  or part of (unpopulated) threaded sub‐
          trees.

       If any of the above constraints is violated, then an attempt to
       write  "threaded"  to  a  cgroup.type file fails with the error
       ENOTSUP.

   The "domain threaded" cgroup type
       According to the pathways described above, the type of a cgroup
       can change to domain threaded in either of the following cases:

       *  The string "threaded" is written to a child cgroup.

       *  A  threaded  controller  is  enabled inside the cgroup and a
          process is made a member of the cgroup.

       A domain threaded cgroup, x, can revert to the type  domain  if
       the  above  conditions  no  longer  hold  true—that  is, if all
       threaded child cgroups of x are removed and either x no  longer
       has  threaded  controllers enabled or no longer has member pro‐
       cesses.

       When a domain threaded cgroup x reverts to the type domain:

       *  All domain invalid descendants of x that are not  in  lower-
          level threaded subtrees revert to the type domain.

       *  The root cgroups in any lower-level threaded subtrees revert
          to the type domain threaded.

   Exceptions for the root cgroup
       The root cgroup of the v2 hierarchy is  treated  exceptionally:
       it  can  be the parent of both domain and threaded cgroups.  If
       the string "threaded" is written to the cgroup.type file of one
       of the children of the root cgroup, then

       *  The type of that cgroup becomes threaded.

       *  The type of any descendants of that cgroup that are not part
          of lower-level threaded subtrees changes to domain invalid.

       Note that in this case, there is no cgroup whose  type  becomes
       domain  threaded.   (Notionally, the root cgroup can be consid‐
       ered as the threaded root for the cgroup whose type was changed
       to threaded.)

       The aim of this exceptional treatment for the root cgroup is to
       allow a threaded cgroup that employs the cpu controller  to  be
       placed  as high as possible in the hierarchy, so as to minimize
       the (small) cost of traversing the cgroup hierarchy.

   The cgroups v2 "cpu" controller and realtime processes
       As at Linux 4.15, the cgroups v2 cpu controller does  not  sup‐
       port  control  of realtime processes, and the controller can be
       enabled in the root cgroup only if all realtime threads are  in
       the  root  cgroup.  (If there are realtime processes in nonroot
       cgroups,  then  a  write(2)  of  the  string  "+cpu"   to   the
       cgroup.subtree_control  file fails with the error EINVAL.  How‐
       ever, on some systems, systemd(1) places certain realtime  pro‐
       cesses  in  nonroot  cgroups in the v2 hierarchy.  On such sys‐
       tems, these processes must first be moved to  the  root  cgroup
       before the cpu controller can be enabled.
]]

Cheers,

Michael

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
