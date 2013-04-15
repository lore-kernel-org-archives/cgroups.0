From: David Shwatrz <dshwatrz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: question about hierarchies
Date: Mon, 15 Apr 2013 21:30:18 +0300
Message-ID: <CAJJAcoe-qA+UF-myzejOFOkgtzbwWN_pMSUngy7BO1YjP1dERA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:x-received:date:message-id:subject:from:to
         :content-type;
        bh=RICzIiEuc0fp8PqVyrxi7vgHt2lo2Y5+pdFqW5p/3Cs=;
        b=yQ+zcDlp0OqutFkMSCfZ0pinS656iV4E+UheYv4X05M73hWUa4tazXrllOtYC/BCjx
         /6SHdl+iAVAzYKAGjhawZI0tJFcekCd0KcwLvW7BhHe32aCZPvds3RHpT2761u3958bO
         YfzBLvLDxh7/PuxcX06jXWJoT5lxM+F7niJJEryBjRAjlNWSNOw6Z8NcikM/xWs9PzNQ
         0mFwZRRwBttzzJUzvasIxpU5ZfSSyeFhw9hbH2l+9R0OLtr/qeOmDSyCt+fZj+97Z9mx
         xJycxvlrOaPM4t0KSeGrmQZs6WsnYrTxnWuys3HjNB+cYLpsB7ecz7gfVvKKx7d0jbst
         +J4Q==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

I am running: (On fedora 18)
mount -t tmpfs tmpfs /cgroup
mkdir /cgroup/test
mount -t cgroup -o cpu,cpuacct test /cgroup/test/

now
ls /cgroup/test/system/
shows all the services that were added by systemd (there are 36 services)
like
dbus.service                sshd.service
cgroup.event_control        firewalld.service       systemd-fsck@.service
cgroup.procs                getty@.service          systemd-journald.service
colord.service              iprdump.service         systemd-logind.service
configure-printer@.service  iprinit.service         systemd-udevd.service
console-kit-daemon.service  iprupdate.service       tasks
cpuacct.stat                ksmtuned.service        udisks2.service
cpuacct.usage               mcelog.service          upower.service
...

What this means is, if I understand correct, is that if I want
to mount another path using the cpu,cpuacct combination in Fedora
(a hierarchy which is mounted by systemd) then
there is no way to avoid replicating the existing hierarchy (if exist);
in the case, the  /sys/fs/cgroup/systemd/system folder with all its
36 or so subfolders. This is what happened in fact; Or is there a way
to avoid this ?

Regards,
DavidS
