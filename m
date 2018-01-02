From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Subject: cgroups(7): documenting cgroups v2 delegation
Date: Tue, 2 Jan 2018 19:22:05 +0100
Message-ID: <1ce0a885-94fb-7480-7180-7b873c95b1bb@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=cc:to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=PV9RXu0+h/X6aNh8hYZRXo/9omAuzq0zAGFQvBvRTEY=;
        b=iPJp8oCVZSuliHqL22LDxm3w5eLz0n2mHrjy3Gj2QxTSz9ZZceh6ay0MhrReE2c8Vx
         REaGuVRgZwhjWL74/yMR5vr4yPThd3Rz99qlQ+66FvrgyoSKBlGvDlDrurlW92JRUK3B
         x2t0QSomDpeJrAgPT7hkkCC1wdoVJHpMvEGIX2l/fqwfjVmW/9643J8vAptvS/xQhBIe
         Tt5KQQSMfI7YbbSXU1yBjg8Hc7JH8sIVv5SpuMEm6Cj0NabzPmKctosiQaa1zGrSwtl/
         LZx+YV387viZMmVzOUX6vJrccN8FwszYXMB2M4+MENFHJbOpn3yKAsjGICRHKbigRO/p
         j9Sw==
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Tejun Heo <tj@kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>
Cc: mtk.manpages@gmail.com, linux-man <linux-man@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, cgroups@vger.kernel.org

Hello Tejun and Serge

The delegation feature of cgroups v2 has of course been around
for a while now, but was not documented so far in cgroups(7).
I have written some text to describe the delegation feature.
I would be happy to receive suggestions for fixes, improvements,
or corrections to errors, from you (or others). The plain-text
version for (easy review) is shown below. (Please note the FIXME!)

The branch containing the pending cgroups(7) changes can be found at: 
https://git.kernel.org/pub/scm/docs/man-pages/man-pages.git/log/?h=draft_cgroup_updates

[[
   Cgroups v2 delegation
       In the context of cgroups, delegation means passing  management
       of  some  subtree  of  the  cgroup hierarchy to a nonprivileged
       process.  Cgroups v1 provides support for delegation  that  was
       accidental  and  not fully secure.  Cgroups v2 supports delega‐
       tion by explicit design.

       Some terminology is required in order to  describe  delegation.
       A delegater is a privileged user (i.e., root) who owns a parent
       cgroup.  A delegatee  is  a  nonprivileged  user  who  will  be
       granted  the  permissions  needed  to  manage some subhierarchy
       under that parent cgroup, known as the delegated subtree.

       To perform delegation, the delegater makes certain  directories
       and  files writable by the delegatee, typically by changing the
       ownership of the objects to be the user ID  of  the  delegatee.
       Assuming that we want to delegate the hierarchy rooted at (say)
       /dlgt_grp and that there are not yet any  child  cgroups  under
       that  cgroup,  the ownership of the following is changed to the
       user ID of the delegatee:

       /dlgt_grp
              Changing the ownership of the root of the subtree  means
              that  any new cgroups created under the subtree (and the
              files they contain) will also be owned by the delegatee.

       /dlgt_grp/cgroup.procs
              Changing the ownership of this file means that the dele‐
              gatee  can move processes into the root of the delegated
              subtree.

       /dlgt_grp/cgroup.subtree_control
              Making this file owned by  the  delegatee  is  optional.
              Doing  so  means that that the delegatee can enable con‐
              trollers  (that  are  present  in  /dlgt_grp/cgroup.con‐
              trollers)  in order to further redistribute resources at
              lower levels in  the  subtree.   As  an  alternative  to
              changing the ownership of this file, the delegater might
              instead add selected controllers to this file.

       The delegater should not change the ownership  of  any  of  the
       controller  interfaces  files  (e.g., pids.max, memory.high) in
       dlgt_grp.  Those files are used from the next level  above  the
       delegated  subtree  in  order  to distribute resources into the
       subtree, and the delegatee should not have permission to change
       the resources that are distributed into the delegated subtree.

       After the aforementioned steps have been performed, the delega‐
       tee can create child cgroups within the delegated  subtree  and
       move  processes  between  cgroups in the subtree.  If some con‐
       trollers are present in dlgt_grp/cgroup.subtree_control, or the
       ownership of that file was passed to the delegatee, the delega‐
       tee can also control the further redistribution of  the  corre‐
       sponding resources into the delegated subtree.

       Some delegation containment rules ensure that the delegatee can
       move processes between cgroups within  the  delegated  subtree,
       but  can't  move  processes  from outside the delegated subtree
       into the subtree or vice versa.  A nonprivileged process (i.e.,
       the  delegatee)  can write the PID of a "target" process into a
       cgroup.procs file only if all of the following are true:

       *  The effective  UID  of  the  writer  (i.e.,  the  delegatee)
          matches  the  real  user  ID or the saved set-user-ID of the
          target process.

       *  The writer has write permission on the cgroup.procs file  in
          the destination cgroup.

       *  The  writer has write permission on the cgroup.procs file in
          the common ancestor of the source and  destination  cgroups.
          (In  some  cases,  the  common ancestor may be the source or
          destination cgroup itself.)

          ┌─────────────────────────────────────────────────────┐
          │FIXME                                                │
          ├─────────────────────────────────────────────────────┤
          │Please confirm that the following is correct:        │
          └─────────────────────────────────────────────────────┘

       Note: one consequence of these delegation containment rules  is
       that  the  unprivileged delegatee can't place the first process
       into the delegated subtree; instead, the delegater  must  place
       the  first  process (a process owned by the delegatee) into the
       delegated subtree.
]]

Cheers,

Michael


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
