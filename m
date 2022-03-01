From: Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Subject: [PATCH 2/2] mm: workingset: Replace IRQ-off check with a lockdep assert.
Date: Tue,  1 Mar 2022 13:21:43 +0100
Message-ID: <20220301122143.1521823-3-bigeasy@linutronix.de>
References: <[PATCH 0/2] Correct locking assumption on PREEMPT_RT>
 <20220301122143.1521823-1-bigeasy@linutronix.de>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1646137310;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MkBV1p2duSsoNMrj3lAoV1bq8psnWoqvtGtulisyZvo=;
        b=mcYC9YHHcxfeuyhzzO2lCCjI97B1nOA6o7f+Uwyv65FMymcttSPv19lKK0WRBL7AZbZGDw
        aW6/JPK8NCu8HtmmwWYRHP7fqixuYxLvWTUq1f9rpVn7iVBmYicO4A90TRaPIOcr6twDKL
        qSemOLDdQeOQnRgxo1DJdQ8gE/LdYCryxzWTKwbgsKSUjABLA58HvsiEjk9lbGKdwGGeeP
        qIFinPAcZ3zfNrAra3yrn95dgOgUfg5Kwmb9JhPcV1PsLb2NVUrEien6uU7lJKi/UeouhT
        pdD99SBzhNcSGsGFQBCYv9fJBW8cUq6TYYfYBDQIQF5l/5fRlEEk4MEuY32p+g==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1646137310;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MkBV1p2duSsoNMrj3lAoV1bq8psnWoqvtGtulisyZvo=;
        b=zAGbPeMcmFPlhqSZK14/x/lmF/lv2bSohWisuiGxy/cWxSlRLJ0WGfH7uPLUaLnAH1b26F
        iSG1Vg00XVK6LhCg==
In-Reply-To: <20220301122143.1521823-1-bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>

Commit
  68d48e6a2df57 ("mm: workingset: add vmstat counter for shadow nodes")

introduced an IRQ-off check to ensure that a lock is held which also
disabled interrupts. This does not work the same way on PREEMPT_RT
because none of the locks, that are held, disable interrupts.

Replace this check with a lockdep assert which ensures that the lock is
held.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
---
 mm/workingset.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/mm/workingset.c b/mm/workingset.c
index 2e4fd7c3296fe..8a3828acc0bfd 100644
--- a/mm/workingset.c
+++ b/mm/workingset.c
@@ -434,6 +434,8 @@ struct list_lru shadow_nodes;
=20
 void workingset_update_node(struct xa_node *node)
 {
+	struct address_space *mapping;
+
 	/*
 	 * Track non-empty nodes that contain only shadow entries;
 	 * unlink those that contain pages or are being freed.
@@ -442,7 +444,8 @@ void workingset_update_node(struct xa_node *node)
 	 * already where they should be. The list_empty() test is safe
 	 * as node->private_list is protected by the i_pages lock.
 	 */
-	VM_WARN_ON_ONCE(!irqs_disabled());  /* For __inc_lruvec_page_state */
+	mapping =3D container_of(node->array, struct address_space, i_pages);
+	lockdep_assert_held(&mapping->i_pages.xa_lock);
=20
 	if (node->count && node->count =3D=3D node->nr_values) {
 		if (list_empty(&node->private_list)) {
--=20
2.35.1

