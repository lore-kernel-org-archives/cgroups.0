From: ricky l <rickylee0815-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: the performance of cgroup regarding resource isolation
Date: Tue, 4 Feb 2014 11:28:47 -0500
Message-ID: <CADoVA9rZn7mu6hmsqE9qtsg76PJo5XE=bmqfpeB3xGNrOw1oHw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:date:message-id:subject:from:to:content-type;
        bh=OMi6gRRKvZep+b36qC2q1OoRsLQ6DX3mRL8yhydIGe0=;
        b=OMdvK0J+LSnOWyC54qG1urFztkNdis9RzF/0G7UZfqFaoD7NQtt672DEFBvgUDnzwj
         IXgNb9pkS8VdyEVkYr9yRi9Bb5/Uvy+YNM7xHpog/Q7c/DuE4X2PtDINZqKLkcO1tmNj
         8CrsaXuA9fZxU0/acstYggv7Le9XTqJu2o5ZJqgy4DDOwX2NtK4LqwEdXBRQrVfvGHTQ
         Aj8j3L/Sd9X5ZkK3pRmB1TQ92M8sraWL+ZVjIEzuURdpcWtgwVpdW8uhra9cpnp6SeOe
         Yw41RV3wRJbsnpIa++UEt7ODoDdgHej2N9i+3WnbBdE/S3zOR2XSul+HQNwC4xPQrDmi
         Wz6g==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Can anyone help me to find documents/blog that describes the
performance of cgroup mainly for CPU resource isolation? I am curious
how well (or accurately) it isolates different groups with different
cfs_quota or cpu.shares. I am also curious how instantaneous the
change of the values take effect. Can someone enlighten me? thx.
