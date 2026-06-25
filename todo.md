# Human Action Item Checklist 🚀

This checklist contains all the manual, real-world tasks you need to perform to complete the integration of your unified personal branding infrastructure. 

---

## 🔒 1. Enable HTTPS Redirection on GitHub Pages
GitHub automatically provisions SSL certificates after domain verification. Once the SSL certificate status changes from "domain verification pending" to "active" (usually takes 5–15 minutes, but can take up to 24 hours):

- [ ] Go to your repository's pages settings: [GitHub Pages settings](https://github.com/dt1900/dt1900.github.io/settings/pages)
- [ ] Scroll down to the **Custom domain** section.
- [ ] Tick the box to **Enforce HTTPS** (if it's greyed out, wait a bit and refresh the page).
- [ ] Verify that navigating to `https://dan-thompson.net` redirects properly without any browser safety warnings.

---

## 🖼️ 2. Establish a Cohesive Profile Picture
To present a unified professional face across the internet, upload your high-resolution profile picture **`1774378152035.png`** to all of your brand profiles.

> [!NOTE]
> The source image is located locally on your computer at:
> `/Users/dan/code/homelab/hosted/dt1900.github.io/img/1774378152035.png`

- [ ] **GitHub**: Update your avatar at [GitHub Profile Settings](https://github.com/settings/profile).
- [ ] **LinkedIn**: Upload the photo to your [LinkedIn Profile page](https://www.linkedin.com/in/danthompson-).
- [ ] **Medium**: Change your profile picture in your [Medium Settings](https://medium.com/me/settings).
- [ ] **RxResume**: Log in to your [RxResume Dashboard](https://rxresu.me/dan.thompson/daniel-thompson) and upload the photo under your profile settings.
- [ ] **Mastodon**: Upload the picture to your self-hosted instance at [Mastodon Settings](https://social.dan-thompson.net/settings/profile).

---

## 🐘 3. Set Up Reciprocal Mastodon Verification
We have added a reciprocal `rel="me"` tag to the Mastodon link on your homepage. Now, you must link back from Mastodon to get the coveted **cryptographically verified green checkmark** on your profile:

- [ ] Log in to your Mastodon instance: [social.dan-thompson.net](https://social.dan-thompson.net)
- [ ] Navigate to **Edit Profile** (or Profile Settings).
- [ ] Scroll down to the **Profile Metadata** section (custom label-value fields).
- [ ] Add a new metadata row:
  * **Label**: `Website` (or `Digital HQ`)
  * **Content**: `https://dan-thompson.net`
- [ ] Click **Save Changes**.
- [ ] Open your public Mastodon profile: [https://social.dan-thompson.net/@dan](https://social.dan-thompson.net/@dan)
- [ ] Verify that the `dan-thompson.net` link is highlighted in a **green box with a checkmark**.

---

## 📬 4. Test Serverless Email Forwarding
Your homepage footer has a `mailto:dan@dan-thompson.net` link. It relies on the AWS SES + S3 + Lambda serverless forwarding stack to forward emails to `thompson.daniel@gmail.com`. Let's make sure it is completely reliable:

- [ ] Open a personal or work email client (do **not** send from your destination `thompson.daniel@gmail.com` to prevent loop-detection or local delivery bypass).
- [ ] Send a test email to **`dan@dan-thompson.net`**.
- [ ] Log into **`thompson.daniel@gmail.com`** and confirm that the test email arrived safely.
- [ ] Check the headers to ensure it passed SPF, DKIM, and DMARC checks (it should, as the Lambda function rewrites headers to comply with AWS SES verification standards).

---

## 📊 5. Confirm Outbound Click Telemetry
The website's Google Analytics tag is active (`G-YD5QJ0K6VG`) and records page views, plus outbound link clicks (Medium, GitHub, LinkedIn, Resume, Mastodon). Let's verify it works in real-time:

- [ ] Log in to your [Google Analytics Dashboard](https://analytics.google.com).
- [ ] In the left sidebar, navigate to **Reports** -> **Realtime**.
- [ ] Open `https://dan-thompson.net` on your phone or in an incognito window on your desktop.
- [ ] Verify that an active user shows up on the real-time map or active users card.
- [ ] Click one of the outbound cards (e.g., your **Medium Blog** or **LinkedIn**).
- [ ] Go back to the Realtime dashboard and wait up to 60 seconds to verify that a `click` event is logged in the **Event count** card with custom parameters (like `link_url`).
