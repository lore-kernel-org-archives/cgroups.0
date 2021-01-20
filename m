From: Kir Kolyshkin <kolyshkin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 00/10] docs: cgroup nits and fixes
Date: Tue, 19 Jan 2021 16:18:14 -0800
Message-ID: <20210120001824.385168-1-kolyshkin@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FQMMF/2jUk+oPAGJT0QPqCY9ZpMVcAq7Q7ndO7jDZtc=;
        b=A/KxEfurUyp8y+7s9StUSf3ir/9EoE/2c4lS5n1+IITvoJo8b3yTx+DDVUl6vNOf04
         36Myvm6/6LlI6Vb9lZmtuzvRetaNBXglRY5umGTeuDe9iJwS1DAabFbaIgfSOz8+TUM3
         MwNUWV5h1Mg4kc0TvYoM8CZylV81Qm5ps2dLqoHkLY8slD8KuYPTbX+5RB4iaP6rZscV
         M/UyrBBwSYeMmuPJfgH1P7qxJRWUHapuWJvtKtqt220WdzJ4CMNDhsBnUYX/w6XlAHeZ
         CXCpSVXyhDjAKtgKrR2JkPL/Sg8WRABGtc2OWiON/xRKfWwo9kNG7QZkDYHwS9AYLJOn
         LGcQ==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: corbet-T1hC0tSOHrs@public.gmane.org
Cc: linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Kir Kolyshkin <kolyshkin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

These are mostly formatting fixes for a few cases where html
looks plain wrong, plus a couple of added cross-references,
and a typo.

All issues spotted while reading cgroup docs. Results are checked
manually for both html and pdf, using both Sphinx 2.4.4 and 3.2.1
for rendering.

All commits are against docs-next@52042e2db

Kir Kolyshkin (10):
  docs/scheduler/sched-bwc: formatting fix
  docs/scheduler/sched-design-CFS: formatting fix
  docs/scheduler/sched-bwc: fix note rendering
  docs/scheduler/sched-bwc: add proper ref
  docs/scheduler/sched-bwc: note/link cgroup v2
  docs/admin-guide: cgroup-v2: typos and spaces
  docs/admin-guide: cgroup-v2: fix cgroup.type rendering
  doc/admin-guide/cgroup-v2: use tables
  docs/admin-guide/cgroup-v2: nit
  docs/admin-guide/cgroup-v2: fix mount opt rendering

 Documentation/admin-guide/cgroup-v2.rst      | 60 +++++++++++---------
 Documentation/scheduler/sched-bwc.rst        | 18 ++++--
 Documentation/scheduler/sched-design-CFS.rst |  6 +-
 Documentation/scheduler/sched-rt-group.rst   |  2 +
 4 files changed, 50 insertions(+), 36 deletions(-)

-- 
2.29.2

